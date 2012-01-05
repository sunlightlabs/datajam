ENV["RAILS_ENV"] ||= 'test'
require 'cover_me'
require File.expand_path("../../config/environment", __FILE__)
require 'rspec/rails'
require 'database_cleaner'
DatabaseCleaner.strategy = :truncation

Dir[Rails.root.join("spec/support/**/*.rb")].each {|f| require f}

RSpec.configure do |config|
  config.include Mongoid::Matchers
  config.mock_with :rr

  config.before(:all) do
    @redis_db = REDIS
    @redis = Redis::Namespace.new(Rails.env.to_s, :redis => @redis_db)
  end

  config.before(:each) do
    DatabaseCleaner.start

    # Create a site template if one doesn't exist.
    unless SiteTemplate.first
      template_text = <<-EOT.strip_heredoc
      <html>
        <head>
          <title>Your Datajam Site</title>
          {{{ head_assets }}}
        </head>

        <body>
          <h1>Site Header</h1>
          {{{ content }}}
          {{{ body_assets }}}
        </body>

      </html>
      EOT
      SiteTemplate.create!(name: 'Site', template: template_text)

    end
  end

  config.after(:each) do
    DatabaseCleaner.clean
    @redis_db.keys("#{Rails.env.to_s}*").each {|key| @redis_db.del(key)}
  end

end
