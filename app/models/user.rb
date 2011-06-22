class User
  include Mongoid::Document
  include Mongoid::Timestamps

  devise :database_authenticatable, :registerable, :lockable,
         :recoverable, :rememberable, :trackable, :validatable

  field :name,        type: String
  field :affiliation, type: String
  field :url,         type: String
end
