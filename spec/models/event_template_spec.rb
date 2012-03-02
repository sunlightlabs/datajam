require 'spec_helper'

describe EventTemplate do
  before(:each) do
    @event_template = EventTemplate.create(name: 'Event Template', template: '')
    @event = Event.create(name: 'Test Event', event_template: @event_template, scheduled_at: Time.now)
  end

  it "should not be destroyed if the template it's in use" do
    @event_template.destroy

    @event_template.errors.blank?.should be_false
    @event_template.destroyed?.should be_false
  end

  it "should be deleted correctly" do
    @event.destroy
    @event.destroyed?.should be_true

    @event_template.destroy
    @event_template.destroyed?.should be_true
  end
end
