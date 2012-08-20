require File.expand_path(File.dirname(__FILE__) + '/acceptance_helper')

feature "Event content" do

  scenario "Load main page" do
    @redis = Redis::Namespace.new(Rails.env.to_s, :redis => REDIS)
    @redis.set('/', 'Welcome to Datajam')
    visit '/'
    page.should have_content('Welcome to Datajam')
  end

  scenario 'Creating an event should add the event reminder' do
    event_template = EventTemplate.create(name: 'Embed Template', template: '{{{event_reminder}}}')
    Event.create(slug: 'test', name: 'test', event_template: event_template, scheduled_at: Time.now + 30.minutes)
    visit '/test'
    page.should have_content('Remind Me')
  end

  scenario 'Creating an event should create an updates.json file' do
    event_template = EventTemplate.create(name: 'Event Template', template: '{{ content_area: My Content Area }}')
    event = Event.create(slug: 'test', name: 'test', event_template: event_template, scheduled_at: Time.now + 30.minutes)
    visit "/event/#{event.id}/updates.json"
    page.should have_content('_id')
  end
end
