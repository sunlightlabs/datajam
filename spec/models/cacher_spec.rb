require 'spec_helper'

describe Cacher do

  before(:each) do

    body = <<-ENDBODY.strip_heredoc
      <h2>{{ header }}</h2>
      <p>{{ description }}</p>
    ENDBODY
    @event_template = EventTemplate.create(name: 'Event Template', template: body)

    embed_body = <<-ENDBODY.strip_heredoc
      <html>
      <body>
        <h1>{{ embed_header }}</h1>
      </body>
      </html>
    ENDBODY
    @embed_template = EmbedTemplate.create(name: 'Large Embed', template: embed_body)

  end

  it "renders an event to the correct path" do

    data = { "header" => "Hello World", "description" => "This is the description." }
    event = Event.create(name: 'Test Event', event_template: @event_template, template_data: data, scheduled_at: Time.now)

    @redis.get('/test-event').should match('<h2>Hello World</h2>')

  end

  it "renders an event to the root path if it's the next event" do

    data = { "header" => "Hello World", "description" => "This is the description." }
    event = Event.create(name: 'Test Event', event_template: @event_template, template_data: data, scheduled_at: Time.now)

    @redis.get('/').should match('<h2>Hello World</h2>')

  end

  it "renders an embed to the correct path" do

    data = { "header" => "Hello World", "embed_header" => "Hello Embedded World" }
    event = Event.create(name: 'Test Event', event_template: @event_template,
                         embed_templates: [@embed_template], scheduled_at: Time.now)

    event.update_attributes!(template_data: data)
    @redis.get('/test-event/large-embed').should match('<h1>Hello Embedded World</h1>')

  end

  it "renders a message at the root path when no events are upcoming" do

    Cacher.cache_events([])
    @redis.get('/').should match('<h2>No upcoming events</h2>')

  end

  it "renders content to a path" do

    Cacher.cache('/foobar','Some content')
    @redis.get('/foobar').should match('Some content')

  end

  it "renders content to a path and adds a leading slash if needed" do

    Cacher.cache('barfoo','Other content')
    @redis.get('/barfoo').should match('Other content')

  end

end
