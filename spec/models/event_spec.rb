require 'spec_helper'

describe Event do

  before(:all) do
    body = <<-ENDBODY.strip_heredoc
      <h2>{{ header }}</h2>
      <p>{{ description }}</p>
    ENDBODY
    @event_template = EventTemplate.create(name: 'Event Template', template: body)
  end

  it "saves template data" do
    data =  { "header" => "Hello World", "description" => "This is the description." }
    event = Event.create(name: 'Test Event', event_template: @event_template, template_data: data)
    event.template_data.should eql({ "header" => "Hello World", "description" => "This is the description." })
  end

  it "creates content areas based on its event template" do

    body = <<-ENDBODY.strip_heredoc
      <h1 id="datajamHeader"></h1>
      <h3 id="datajamSubheader"></h3>
      <div data-content-area="Test Content Area"></div>
    ENDBODY
    template = EventTemplate.create(name: 'Event Template', template: body)
    event = Event.create(name: 'Test Event', event_template: template)
    event.content_areas.first.name.should eql("Test Content Area")

  end
end
