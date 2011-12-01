require 'spec_helper'

describe Event do

  before(:each) do
    body = <<-ENDBODY.strip_heredoc
      <h2>{{ header }}</h2>
      <p>{{ description }}</p>
    ENDBODY
    @event_template = EventTemplate.create(name: 'Event Template', template: body)
  end

  it "uses id as to_param" do
    event = Event.create(name: 'Test Event', event_template: @event_template)
    event.to_param.should eql(event.id.to_s)
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

  it "#render adds asset tags" do

    event = Event.create(name: 'Test Event', event_template: @event_template,
                         template_data: {"header" => "Hello World"})

    event.render.should match(/datajam\.js/)

  end


  it "saves template data for both event templates and embed templates" do

    body = <<-ENDBODY
      <html>
        <head>
       {{{ head_assets }}}
       </head>
        <body>
          <h1>{{ embed_header }}</h1>
          {{{ body_assets }}}
        </body>
      </html>
    ENDBODY
    embed_template = EmbedTemplate.create(name: 'Embed Template', template: body)
    event = Event.create(name: 'Test Event', event_template: @event_template, embed_templates: [embed_template])
    event.update_attributes template_data: {"embed_header" => "Hello Embed", "description" => "The Description"}

    event.template_data.should eql({ "header" => "", "description" => "The Description", "embed_header" => "Hello Embed" })

  end

  it "#rendered_embeds adds asset tags" do

    body = <<-ENDBODY
      <html>
        <head>
       {{{ head_assets }}}
       </head>
        <body>
          <h1>{{ embed_header }}</h1>
          {{{ body_assets }}}
        </body>
      </html>
    ENDBODY
    embed_template = EmbedTemplate.create(name: 'Embed Template', template: body)
    event = Event.create(name: 'Test Event', event_template: @event_template, embed_templates: [embed_template])
    event.update_attributes template_data: {"embed_header" => "Hello World"}

    event.rendered_embeds['embed-template'].should match('<h1>Hello World</h1>')
    event.rendered_embeds['embed-template'].should match(/datajam\.js/)

  end

end
