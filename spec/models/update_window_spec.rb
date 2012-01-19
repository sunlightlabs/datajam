require 'spec_helper'

describe UpdateWindow do

  before(:each) do

    body = <<-ENDBODY.strip_heredoc
      <h2>{{ header }}</h2>
      <p>{{ description }}</p>
      {{ content_area: Test Area }}
    ENDBODY
    event_template = EventTemplate.create(name: 'Event Template', template: body)
    data =  { "header" => "Hello World", "description" => "This is the description." }
    @event = Event.create(name: 'Test Event', event_template: event_template, template_data: data)

  end

  it 'adds a content update' do
    window = UpdateWindow.create(event: @event)
    window.content_updates.new(html: '<h1>Some HTML</h1>')

    window.content_updates.first.html.should eql('<h1>Some HTML</h1>')
  end

  it 'creates a next_window after 20 content updates' do

    window = UpdateWindow.create(event: @event)

    25.times do |i|
      @event.add_content_update(html: "Update #{i}", content_area_id: @event.content_areas.first.id)
    end

    current_updates = @event.current_window.content_updates
    current_updates.length.should eql(5)
    current_updates.last.html.should match(/Update 24/)
    @event.content_areas.first.html.should match(/Update 24/)

    prev_updates = @event.current_window.previous_window.content_updates
    prev_updates.length.should eql(20)
    prev_updates.last.html.should match(/Update 19/)

    @event.current_window.previous_window.next_window.id.should eql(@event.current_window.id)
  end

end
