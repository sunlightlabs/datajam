class Event
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Slug
  include RendersTemplates

  include Tag::Taggable

  attr_accessor :cached_render, :_head_assets, :_body_assets

  has_many :reminders

  field :name,            type: String
  field :scheduled_at,    type: Time
  field :status,          type: String,  default: 'Upcoming'
  field :template_data,   type: Hash,    default: {}
  field :activities,      type: Hash,    default: {}
  field :content_updates, type: Array,   default: []

  slug :name, permanent: true

  embeds_many :content_areas, cascade_callbacks: true

  validates :name, presence: true, unique_slug: { message: "generates a slug that has already been taken" }
  validates_datetime :scheduled_at, { message: 'must be a valid date/time' }

  belongs_to :event_template
  has_and_belongs_to_many :embed_templates
  has_and_belongs_to_many :users
  has_one :current_window, class_name: 'UpdateWindow', validate: false

  index :name

  default_scope order_by([[:status, :desc], [:scheduled_at, :desc]])

  before_save :update_template_data, :generate_content_areas, :cache_render

  after_save do
    UpdateWindow.create(event: self) if self.current_window.nil?
    Cacher.cache_events([self])
    Cacher.cache_archives # regenerate the archives
  end

  after_destroy do
    # FIXME: This is going to get slow
    Cacher.reset!
  end

  scope :upcoming, where(status: 'Upcoming').order_by([[:scheduled_at, :asc]])
  scope :finished, where(status: 'Finished').order_by([[:scheduled_at, :desc]])

  # Mongoid::Slug changes this to `self.slug`. Undo that.
  def to_param
    id.to_s
  end

  def reminder_form
    @reminder_form ||= render_to_string partial: 'shared/reminder_form', locals: { event: self }
  end

  def script_id
    @script_id ||= render_to_string partial: 'shared/script_id', locals: { event: self }
  end

  def cache_render
    @cached_render = render
  rescue V8::JSError
    errors.add(:base, "template #{self.event_template.name} contains errors" )
    errors.blank?
  rescue ActionView::Template::Error
    errors.add(:base, "one or more asset templates contain errors" )
  end

  # Render the HTML for an event page
  def render
    rendered_content = preprocess_template(event_template)
      .render_with(
        template_data.merge({
          event_reminder: reminder_form
        }))
    SiteTemplate.first.render_with({ content: rendered_content,
                                     head_assets: _head_assets,
                                     body_assets: script_id + _body_assets})
  end

  # Render the HTML for an embed
  def rendered_embeds
    embeds = {}
    embed_templates.each do |embed_template|
      template_to_render = preprocess_template(embed_template)
      data = template_data.merge({
        head_assets: _head_assets,
        body_assets: script_id + _body_assets
      })
      embeds[embed_template.slug] = template_to_render.render_with(data)
    end
    embeds
  end

  # Convert content areas from Handlebars to HTML
  def preprocess_template(template)
    self._head_assets = head_assets
    self._body_assets = body_assets
    content_areas.each do |content_area|
      # only render assets once for each type
      unless _head_assets.include?(content_area.render_head)
        self._head_assets += content_area.render_head
      end
      unless _body_assets.include?(content_area.render_body)
        self._body_assets += content_area.render_body
      end
      template.template.gsub!(/\{\{([\w ]*):( *)#{content_area.name} \}\}/, content_area.render)
    end
    template
  end

  def add_content_update(params)

    if self.current_window.content_updates.length > 19

      # Create a new update window and set it as the next window.
      new_window = UpdateWindow.create(previous_window: self.current_window)

      self.current_window.next_window = new_window
      self.current_window.save

      # The new window is now the current window.
      self.current_window = new_window
    end
    self.current_window.content_updates.create(
      params.keep_if{|k,v| ContentUpdate.fields.include? k.to_s }
    )
    self.save
    self.current_window.reload

    cache_updates
  end

  def finalize!
    self.status = "Finished"
    save!
  end

  def reopen!
    self.status = "Upcoming"
    save!
  end

  def as_json(options = {})
    super.merge(unix_scheduled_at: scheduled_at.to_i,
                content_areas: content_areas.collect {|area| area.as_json })
  end

  # Public: Returns the list of taggables that share tags with this event. If
  # this event has no tags, then it returns the full passed-in collection, as
  # is.
  #
  # collection - a Collection of Taggable objects.
  #
  # Returns a filtered collection.
  def filter_by_tags(collection)
    return collection if tag_list.empty?

    ids = []
    type = collection.first.class.to_s
    Tag.any_in(name: tag_list.push('global')).each do |tag|
      tag.taggable_references.where(taggable_type: type).each do |ref|
        ids.push ref.taggable_id
      end
    end
    collection.any_in(_id: ids)
  end

  protected

  def cache_updates
    Cacher.cache('/event/' + self.id.to_s + '/updates.json', self.current_window.to_json)
  end

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
    clean_record_names = []
    ([event_template] + embed_templates).each do |template|
      template.custom_areas.each do |name, area_type|
        existing = self.content_areas.where(name: name)
        clean_record_names << name
        unless existing.any?
          klass = area_type.classify.constantize
          self.content_areas << klass.new(name: name, area_type: area_type)
        else
          existing.each do |area|
            area.set(:name, name)
            area.set(:area_type, area_type)
          end
        end
      end
    end
    remove = self.content_areas.not_in name: clean_record_names
    remove.destroy_all
  end
end
