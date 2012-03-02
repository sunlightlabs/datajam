require 'spec_helper'

describe ContentArea do

  before(:each) do
    body = <<-ENDBODY.strip_heredoc
      <h2>{{ header }}</h2>
      <p>{{ description }}</p>
    ENDBODY
    event_template = EventTemplate.create(name: 'Event Template', template: body)
    data =  { "header" => "Hello World", "description" => "This is the description." }
    @event = Event.create(name: 'Test Event', event_template: event_template, template_data: data, scheduled_at: Time.now)
  end

  it "sets area type based on the class name" do
    @event.content_areas << ContentArea.new(name: 'Some Area')

    @event.content_areas.last.area_type.should eql('content_area')
  end

  it "sets area type based on the subclassed class name" do
    class LiveChat < ContentArea
    end
    @event.content_areas << LiveChat.new(name: 'Chat Box')

    @event.content_areas.last.area_type.should eql('live_chat')
  end

  it "renders itself inside a div with its id set" do
    @event.content_areas << ContentArea.new(name: 'Some Area', html: '<h1>Hello World</h1>')
    ca = @event.content_areas.last

    rendered = "<div id=\"content_area_#{ca.id}\"><h1>Hello World</h1></div>"
    ca.render.should eql(rendered)
  end

end
