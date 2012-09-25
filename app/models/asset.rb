class Asset
  include Mongoid::Document
  include Mongoid::Timestamps

  field :name, type: String
  mount_uploader :asset, AssetUploader, mount_on: :asset_filename
  validates :asset, presence: true
  skip_callback :destroy, :after, :remove_asset!
end
