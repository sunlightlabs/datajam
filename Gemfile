source 'http://rubygems.org'

gem 'rails',                '~> 3.1.0'
gem 'unicorn',              '~> 3.4'
gem 'capistrano',           '~> 2.5'
gem "jquery-rails",         '~> 0.2'
gem 'mongoid',              '~> 2.4'
gem 'bson',                 '1.6.2'
gem 'bson_ext',             '1.6.2'
gem 'carrierwave',          '~> 0.5'
gem 'carrierwave-mongoid',            require: 'carrierwave/mongoid'
gem 'mongoid_slug',         '~> 0.7', require: 'mongoid/slug'
gem 'rack-gridfs',          '~> 0.4'
gem 'rack-rewrite',         '~> 1.2'
gem 'devise',               '~> 1.1'
gem 'redis',                '~> 2.2'
gem 'redis-namespace',      '~> 0.10'
gem 'chronic',              '~> 0.4'
gem 'validates_timeliness', '~> 3.0.2'
gem 'escape_utils',         '~> 0.2' # http://crimpycode.brennonbortz.com/?p=42
gem 'nokogiri',             '~> 1.5'
gem 'hbs',                  '~> 0.1', require: 'handlebars'
gem 'formatize',            '~> 1.0'
gem 'mini_magick',          '~> 3.4'
gem 'simple_form',          '~> 2.0'
gem 'bigdecimal'
gem 'time_diff'

group :development do
  gem 'thin'
  gem 'minitest'
  gem 'map_by_method'
  gem 'what_methods'
  gem 'awesome_print'
  gem 'net-http-spy', git: 'git://github.com/nu7hatch/net-http-spy.git'
  gem 'hirb'
  gem 'looksee'
  gem 'wirble'
  gem 'sketches'
  gem 'debugger'
  gem 'httparty'
end

group :development, :test do
  gem 'rspec-rails',       '~> 2.7'
  gem 'rr',                '~> 1.0'
  gem 'capybara',          '~> 1.1'
  gem 'mongoid-rspec',     '~> 1.4'
  gem 'database_cleaner',  '~> 0.6'
  gem 'rocco',             git: 'https://github.com/rtomayko/rocco.git'
  gem 'jasmine',           '~> 1.1'
  gem 'pygmentize',        '~> 0.0.2'
  gem 'guard-rspec',       '~> 0.5'
  gem 'mocha',             '0.11.4'
end

begin
    eval(File.read(File.expand_path('../Pluginfile', __FILE__)), binding)
rescue
    puts "[Warning] No Pluginfile found. To generate one, run `rake plugins`."
end
