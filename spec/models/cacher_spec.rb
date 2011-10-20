require 'spec_helper'

describe Cacher do

  before(:all) do
    @redis = Redis::Namespace.new(Rails.env.to_s, :redis => Redis.new)

    body = <<-ENDBODY.strip_heredoc
      <h2>{{ header }}</h2>
      <p>{{ description }}</p>
    ENDBODY
    @event_template = EventTemplate.create(name: 'Event Template', template: body)

    embed_body = <<-ENDBODY.strip_heredoc
      <html>
      <body>
        <h1>{{ embedded_header }}</h1>
      </body>
      </html>
    ENDBODY
    @embed_template = EmbedTemplate.create(name: 'Large Embed', template: embed_body)

  end

  it "renders an event to the correct path" do

    data = { "header" => "Hello World", "description" => "This is the description." }
    event = Event.create(name: 'Test Event', event_template: @event_template, template_data: data)

    @redis.get('/test-event').should match('<h2>Hello World</h2>')

  end

  it "renders an event to the root path if it's the next event" do

    data = { "header" => "Hello World", "description" => "This is the description." }
    event = Event.create(name: 'Test Event', event_template: @event_template, template_data: data)

    @redis.get('/').should match('<h2>Hello World</h2>')

  end

  it "renders an embed to the correct path" do

    data = { "embedded_header" => "Hello Embedded World" }
    event = Event.create(name: 'Test Event',
                         event_template: @event_template,
                         template_data: data,
                         embed_templates: [@embed_template])

    @redis.get('/test-event/large-embed').should match('<h1>Hello Embedded World</h1>')

  end

  it "renders a message at the root path when no events are upcoming" do

    Cacher.cache_events([])

    @redis.get('/').should match('<h2>No upcoming events</h2>')

  end

end
