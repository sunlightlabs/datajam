class Reminder
  include Mongoid::Document

  field :email, type: String
  field :sent,  type: Boolean, default: false

  belongs_to :event

  validates :email, presence: true, email_format: true, uniqueness: { scope: :event_id, message: 'is already going to be notified' }

  def sent!
    update_attributes(sent: true)
  end
end
