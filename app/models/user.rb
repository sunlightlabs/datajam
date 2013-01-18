class User
  include Mongoid::Document
  include Mongoid::Timestamps

  devise :database_authenticatable,
         :rememberable, :trackable, :validatable

  field :name,        type: String
  field :affiliation, type: String
  field :url,         type: String

  index :name
  index :affiliation
  index :url

  before_validation :leave_admin_alone, on: :update

  before_destroy do |user|
    if user.name == 'Admin'
      errors.add(:username, "This user can't be deleted")
      return false
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

  protected

  def leave_admin_alone
    if user.name == 'Admin' || user.name_was == 'Admin'
      if user.name_changed?
        errors.add(:name, "Name can't be changed for this user")
        return false
      end
      if user.email_changed?
        errors.add(:email, "Email can't be changed for this user")
        return false
      end
      if user.encrypted_password_changed?
        errors.add(:password, "Password can't be changed for this user")
        return false
      end
    end
  end

end
