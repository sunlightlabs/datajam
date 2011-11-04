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
      <h1>{{ header }}</h1>
      <h3>{{ subheader }}</h3>
      {{ content_area: Test Content Area }}
    ENDBODY
    template = EventTemplate.create(name: 'Event Template', template: body)
    event = Event.create(name: 'Test Event', event_template: template)

    event.content_areas.first.name.should eql("Test Content Area")

  end

  it "Event#render adds asset tags" do

    event = Event.create(name: 'Test Event', event_template: @event_template, template_data: {"header" => "Hello World"})

    event.render.should match(/datajam\.js/)

  end

  it "Event#render_embeds adds asset tags" do

    body = <<-ENDBODY
      <html>
        <head>
       {{{ head_assets }}}
       </head>
        <body>
          <h1>{{ header }}</h1>
          {{{ body_assets }}}
        </body>
      </html>
    ENDBODY
    embed_template = Template.create(name: 'Embed Template', template: body)
    event = Event.create(name: 'Test Event', event_template: @event_template, template_data: {"header" => "Hello World"},embed_templates: [embed_template])

    event.rendered_embeds['embed-template'].should match(/datajam\.js/)

  end

end
