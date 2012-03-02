require 'spec_helper'

describe EmbedTemplate do
  before(:each) do
    event_template = EventTemplate.create(name: 'Event Template', template: '')
    @embed_template = EmbedTemplate.create(name: 'Embed Template', template: '')
    @event = Event.create(name: 'Test Event', event_template: event_template, embed_templates: [@embed_template], scheduled_at: Time.now)
  end

  it "should not be destroyed if the template it's in use" do
    @embed_template.destroy

    @embed_template.errors.blank?.should be_false
    @embed_template.destroyed?.should be_false
  end

  it "should be deleted correctly" do
    @event.destroy
    @event.destroyed?.should be_true

    @embed_template.destroy
    @embed_template.destroyed?.should be_true
  end
end
