class User
  include Mongoid::Document
  include Mongoid::Timestamps

  devise :database_authenticatable, :lockable,
         :recoverable, :rememberable, :trackable, :validatable

  field :name,        type: String
  field :affiliation, type: String
  field :url,         type: String

  index :name
  index :affiliation
  index :url

  before_validation do |user|
    if user.email_changed?
      errors.add(:email, 'Email can\'t be changed for this user')
    end
    if user.password_changed?
      errors.add(:password, 'Password can\'t be changed for this user')
    end
  end

  mount_uploader :avatar, AvatarUploader

  default_scope order_by([:name, :asc])

  def as_json(options={})
    super(
      options.merge(
        :only => [
          :_id,
          :affiliation,
          :created_at,
          :email,
          :name,
          :updated_at,
          :url
        ],
        :methods => [
          :small_avatar_url
        ]
      )
    )
  end

  def small_avatar_url
    avatar_url(:small)
  end
end
