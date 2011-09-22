class Event
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Slug

  field :name,           type: String
  field :scheduled_at,   type: Time
  field :status,         type: String,  default: 'Upcoming'
  field :template_data,  type: Hash
  field :activities,     type: Hash

  slug :name, permanent: true

  validates_presence_of :name

  belongs_to :event_template
  has_and_belongs_to_many :embed_templates
  has_and_belongs_to_many :users

  before_save :update_template_data

  scope :upcoming, where(status: 'Upcoming').order_by([[:scheduled_at, :asc]])

  # Mongoid::Slug changes this to `self.slug`. Undo that.
  def to_param
    self.id.to_s
  end

  def after_save
    Rails.logger.debug "Inside Event#after_save"
    Cacher.cache_events([self])
  end

  protected

  def update_template_data
    self.template_data = {} if self.event_template_id_changed? || self.template_data.nil?
    t = Template.find(self.event_template_id)
    t.custom_fields.each do |f|
      self.template_data[f] ||= ''
    end if t.custom_fields
  end

end

