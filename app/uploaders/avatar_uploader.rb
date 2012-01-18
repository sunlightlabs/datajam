class AvatarUploader < CarrierWave::Uploader::Base
  include CarrierWave::MiniMagick

  version :small do
    process :resize_to_fill => [100, 100]
  end

  version :large do
    process :resize_to_fill => [300, 300]
  end

  def store_dir
    "#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end
end
