class TemplateUploader < CarrierWave::Uploader::Base

  def store_dir
    "templates"
  end

  def extension_white_list
    %w(html)
  end


end
