CarrierWave.configure do |config|
  if Rails.env.test?
    config.storage = :file
    config.enable_processing = false
  else
    config.storage = :grid_fs
    config.grid_fs_connection = Mongoid.database
    config.grid_fs_access_url = "/static"
  end
end
