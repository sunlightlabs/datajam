require "spec_helper"

describe NotificationMailer do
  it "should send mail correctly" do
    event_template = EventTemplate.create(name: 'Event Template', template: '')

    event = Event.create(name: 'Event 1', event_template: event_template, scheduled_at: Time.now + 30.minutes)
    event.reminders.create(email: 'sample@sample.com')
    email = NotificationMailer.event_reminder(event, event.reminders.first).deliver

    ActionMailer::Base.deliveries.empty?.should be_false
    email.to.should == ["sample@sample.com"]
    email.body.should have_content(event.name)
    email.body.should have_content(event.scheduled_at.strftime("%I:%M %P"))
  end
end
