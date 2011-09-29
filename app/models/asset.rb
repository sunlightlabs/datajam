class Asset
  include Mongoid::Document
  include Mongoid::Timestamps

  field :name, type: String
  mount_uploader :asset, AssetUploader, mount_on: :asset_filename
end
