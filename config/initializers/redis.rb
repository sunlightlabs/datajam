settings = YAML.load(ERB.new(File.read("#{Rails.root}/config/redis.yml")).result)[Rails.env]
uri = settings['uri']
begin
  uri = URI.parse(uri)
  REDIS = Redis.new(:host => uri.host, :port => uri.port, :password => uri.password)
rescue
  REDIS = Redis.new
end