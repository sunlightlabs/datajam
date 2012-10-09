require "spec_helper"

describe SendRemindersJob do
  before do
    ActionMailer::Base.delivery_method = :test
  end

  it "should send notifications to upcoming events" do
    event_template = EventTemplate.create(name: 'Event Template', template: '')

    event1 = Event.create(name: 'Event 1', event_template: event_template, scheduled_at: Time.now + 30.minutes)
    event2 = Event.create(name: 'Event 2', event_template: event_template, scheduled_at: Time.now + 1.day)
    event3 = Event.create(name: 'Event 3', event_template: event_template, scheduled_at: Time.now - 6.hours)

    event1.reminders.create(email: 'sample@sample.com')
    event2.reminders.create(email: 'sample@sample.com')
    event3.reminders.create(email: 'sample@sample.com')

    SendRemindersJob.perform

    event1.reminders.where(sent: true).count.should be(1)
    event2.reminders.where(sent: true).count.should be(0)
    event3.reminders.where(sent: true).count.should be(0)
  end
end
