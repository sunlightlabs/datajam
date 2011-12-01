require 'spec_helper'

describe UpdateWindow do

  it 'adds a content update' do
    window = UpdateWindow.create
    window.content_updates.new(html: '<h1>Some HTML</h1>')

    window.content_updates.first.html.should eql('<h1>Some HTML</h1>')
  end

  it 'creates a next_window after 20 content updates' do

    body = <<-ENDBODY.strip_heredoc
      <h2>{{ header }}</h2>
      <p>{{ description }}</p>
    ENDBODY
    event_template = EventTemplate.create(name: 'Event Template', template: body)
    data =  { "header" => "Hello World", "description" => "This is the description." }
    event = Event.create(name: 'Test Event', event_template: event_template, template_data: data)
    window = UpdateWindow.create(event: event)

    25.times do |i|
      event.current_window.content_updates.new(html: "Update #{i}")
      event.current_window.save
    end

    current_updates = event.current_window.content_updates
    current_updates.length.should eql(5)
    current_updates.last.html.should eql("Update 24")

    prev_updates = event.current_window.previous_window.content_updates
    prev_updates.length.should eql(20)
    prev_updates.last.html.should eql("Update 19")

    event.current_window.previous_window.next_window.id.should eql(event.current_window.id)
  end

end
