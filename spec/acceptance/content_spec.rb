require File.expand_path(File.dirname(__FILE__) + '/acceptance_helper')

feature "Event content" do

  scenario "Load main page" do
    @redis = Redis::Namespace.new(Rails.env.to_s, :redis => REDIS)
    @redis.set('/', 'Welcome to Datajam')
    visit '/'
    page.should have_content('Welcome to Datajam')
  end
end
