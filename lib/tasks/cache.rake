namespace :cache do
  desc "Initialize the cache"
  task :prime => :reset

  desc "Reset redis for Events and Archives"
  task :reset => :environment do
    Cacher.reset!
  end
end
