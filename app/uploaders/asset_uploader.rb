class AssetUploader < CarrierWave::Uploader::Base

  def store_dir
    "assets"
  end

end
