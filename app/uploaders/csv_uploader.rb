class CsvUploader < CarrierWave::Uploader::Base

  def store_dir
    "csv"
  end

  def extension_white_list
    %w(csv)
  end

end
