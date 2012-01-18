class User
  include Mongoid::Document
  include Mongoid::Timestamps

  devise :database_authenticatable, :lockable,
         :recoverable, :rememberable, :trackable, :validatable

  field :name,        type: String
  field :affiliation, type: String
  field :url,         type: String

  mount_uploader :avatar, AvatarUploader

  def as_json(options={})
    super(options.merge :only => [
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
