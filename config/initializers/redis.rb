settings = YAML.load_file "#{Rails.root}/config/redis.yml"
uri = settings[Rails.env].uri
if uri?
  uri = URI.parse(uri)
  REDIS = Redis.new(:host => uri.host, :port => uri.port, :password => uri.password)
else
  REDIS = Redis.new
end