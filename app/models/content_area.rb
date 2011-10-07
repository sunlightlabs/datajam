class ContentArea
  include Mongoid::Document
  include Mongoid::Timestamps

  field :name,      type: String
  field :html,      type: String
  field :template,  type: String
  field :data,      type: Hash

  belongs_to :event
end
