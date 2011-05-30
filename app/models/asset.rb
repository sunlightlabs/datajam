class Asset
  include Mongoid::Document
  include Mongoid::Timestamps

  field :name, type: String
  mount_uploader :asset, AssetUploader
end
