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

  belongs_to :template
  has_and_belongs_to_many :users

  before_save :update_template_data

  scope :upcoming, where(status: 'Upcoming').order_by([[:scheduled_at, :asc]])

  # Mongoid::Slug changes this to `self.slug`. Undo that.
  def to_param
    self.id.to_s
  end

  protected

  def update_template_data
    return unless self.template_id_changed?
    t = Template.find(self.template_id)
    self.template_data = {}
    t.custom_fields.each do |f|
      self.template_data[f] = ''
    end if t.custom_fields
  end

end

