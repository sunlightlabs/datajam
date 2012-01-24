class Event
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Slug

  attr_accessor :head_assets, :body_assets

  field :name,            type: String
  field :scheduled_at,    type: Time
  field :status,          type: String,  default: 'Upcoming'
  field :template_data,   type: Hash,    default: {}
  field :activities,      type: Hash,    default: {}
  field :content_updates, type: Array,   default: []

  slug :name, permanent: true

  validates_presence_of :name

  belongs_to :event_template
  has_and_belongs_to_many :embed_templates
  embeds_many :content_areas
  has_and_belongs_to_many :users
  has_one :current_window, class_name: 'UpdateWindow', validate: false

  before_save :update_template_data, :generate_content_areas

  after_save do
    Cacher.cache_events([self])
    if self.current_window.nil?
      UpdateWindow.create(event: self)
    end
  end

  scope :upcoming, where(status: 'Upcoming').order_by([[:scheduled_at, :asc]])

  # Mongoid::Slug changes this to `self.slug`. Undo that.
  def to_param
    self.id.to_s
  end

  def script_id
    <<-EOT.strip_heredoc
    <script type="text/javascript">
    window.Datajam || (Datajam = {});
    Datajam.eventId = "#{self.id.to_s}";
    Datajam.DEBUG = #{(Rails.env.to_s == 'production' && 'false') || 'true'};
    Datajam.debug = function(msg){
      Datajam.DEBUG && window.console && console.log(msg);
    }
    </script>
    EOT
  end

  # Render the HTML for an event page
  def render
    self.head_assets = HEAD_ASSETS
    self.body_assets = BODY_ASSETS
    rendered_content = preprocess_template(self.event_template).render_with(self.template_data)
    SiteTemplate.first.render_with({ content: rendered_content,
                                     head_assets: head_assets,
                                     body_assets: self.script_id + body_assets})
  end

  # Render the HTML for an embed
  def rendered_embeds
    embeds = {}
    self.embed_templates.each do |embed_template|
      data = self.template_data.merge({"head_assets" => HEAD_ASSETS, "body_assets" => self.script_id + BODY_ASSETS})
      embeds[embed_template.slug] = preprocess_template(embed_template).render_with(data)
    end
    embeds
  end

  # Convert content areas from Handlebars to HTML
  def preprocess_template(template)
    self.content_areas.each do |content_area|
      # only render assets once for each type
      unless head_assets.include?(content_area.render_head)
        self.head_assets += content_area.render_head
      end
      unless body_assets.include?(content_area.render_body)
        self.body_assets += content_area.render_body
      end
      template.template.gsub!(/\{\{([\w ]*):( *)#{content_area.name} \}\}/, content_area.render)
    end
    template
  end

  def add_content_update(params)

    if self.current_window.content_updates.length > 19

      # Create a new update window and set it as the next window.
      new_window = UpdateWindow.new(previous_window: self.current_window)

      self.current_window.next_window = new_window
      self.current_window.save

      # The new window is now the current window.
      self.current_window = new_window
    end
    self.current_window.content_updates.create(params)
    self.save
    self.reload

    Cacher.cache('/event/' + self.id.to_s + '/updates.json', self.current_window.to_json)
  end


  protected

  def update_template_data
    self.template_data ||= {}
    fresh_fields = []

    # Find all custom fields from all templates.
    templates = ([self.event_template] + self.embed_templates).compact
    templates.each do |t|
      t.custom_fields.each do |f|
        # Add to hash if needed.
        self.template_data[f] ||= ''
        # Cache the field name for the deletion step below.
        fresh_fields << f
      end if t.custom_fields
    end

    # Remove custom fields that are no longer relevant.
    self.template_data.delete_if { |k,v| !fresh_fields.include?(k) }
  end

  def generate_content_areas
    ([event_template] + embed_templates).each do |template|
      template.custom_areas.each do |name, area_type|
        existing = self.content_areas.where(name: name, area_type: area_type)
        unless existing.any?
          klass = area_type.titleize.gsub(' ','').constantize
          self.content_areas << klass.new(name: name, area_type: area_type)
        else
          existing.each do |area|
            area.update_attributes(name: name, area_type: area_type)
          end
        end
      end
    end
  end

end
