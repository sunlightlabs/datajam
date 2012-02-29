namespace :cache do
  desc "Reset redis for Events and Archives"
  task :reset => :environment do
    Cacher.reset!
  end
end
