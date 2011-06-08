class Event
  include Mongoid::Document
  include Mongoid::Timestamps

  field :name,           type: String
  field :scheduled_at,   type: Time
  field :status,         type: String,  default: 'Upcoming'
  field :template_data,  type: Hash
  field :activities,     type: Hash

  belongs_to :template
  has_and_belongs_to_many :users

end

