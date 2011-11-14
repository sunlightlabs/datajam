class User
  include Mongoid::Document
  include Mongoid::Timestamps

  devise :database_authenticatable, :lockable,
         :recoverable, :rememberable, :trackable, :validatable

  field :name,        type: String
  field :affiliation, type: String
  field :url,         type: String

  def as_json(options={})
    super(:only => [
      :_id,
      :affiliation,
      :created_at,
      :email,
      :name,
      :updated_at,
      :url
    ])
  end

end
