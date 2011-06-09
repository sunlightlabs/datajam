class Event
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Slug

  field :name,           type: String
  field :scheduled_at,   type: Time
  field :status,         type: String,  default: 'Upcoming'
  field :template_data,  type: Hash
  field :activities,     type: Hash

  slug :name

  belongs_to :template
  has_and_belongs_to_many :users

  # Mongoid::Slug changes this to `self.slug`. No thanks.
  def to_param
    self.id.to_s
  end
end

