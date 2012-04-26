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
    event = Event.create(name: 'Test Event', event_template: @event_template, scheduled_at: Time.now)
    event.to_param.should eql(event.id.to_s)
  end

  it "saves template data" do

    data =  { "header" => "Hello World", "description" => "This is the description." }
    event = Event.create(name: 'Test Event', event_template: @event_template, template_data: data, scheduled_at: Time.now)

    event.template_data.should eql({ "header" => "Hello World", "description" => "This is the description." })

  end

  it "creates content areas based on its event template" do
    body = <<-ENDBODY.strip_heredoc
      <h1>{{ header }}</h1>
      <h3>{{ subheader }}</h3>
      <div>{{ content_area: Test Content Area }}</div>
    ENDBODY
    template = EventTemplate.create(name: 'Event Template', template: body)
    event = Event.create(name: 'Test Event', event_template: template, scheduled_at: Time.now)

    event.content_areas.first.name.should eql("Test Content Area")

    body = <<-ENDBODY.strip_heredoc
      <h1>{{ header }}</h1>
      <h3>{{ subheader }}</h3>
      <div>{{ content_area: Test Content Area }}</div>
      <div>{{ content_area: Another Content Area }}</div>
    ENDBODY
    template.update_attributes(template: body)
  end

  it "removes unused content areas" do
    body = <<-ENDBODY.strip_heredoc
      <h1>{{ header }}</h1>
      <h3>{{ subheader }}</h3>
      {{ content_area: Test Content Area }}
    ENDBODY

    updated_body = <<-BODY
      {{ content_area: Updated Test Content Area }}
    BODY

    template = EventTemplate.create(name: 'Event Template', template: body)
    event = Event.create(name: 'Test Event', event_template: template, scheduled_at: Time.now)

    template.update_attributes(template: updated_body)
    event.content_areas.all.to_a.map(&:name).should == ["Updated Test Content Area"]
  end

  it "#render adds asset tags" do

    event = Event.create(name: 'Test Event', event_template: @event_template,
                         template_data: {"header" => "Hello World"}, scheduled_at: Time.now)

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
    event = Event.create(name: 'Test Event', event_template: @event_template, embed_templates: [embed_template], scheduled_at: Time.now)
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
    event = Event.create(name: 'Test Event', event_template: @event_template, embed_templates: [embed_template], scheduled_at: Time.now)
    event.update_attributes template_data: {"embed_header" => "Hello World"}

    event.rendered_embeds['embed-template'].should match('<h1>Hello World</h1>')
    event.rendered_embeds['embed-template'].should match(/datajam\.js/)

  end

  it "#finalize! marks the event as finished" do
    event = Event.create(name: 'Test Event', event_template: @event_template, scheduled_at: Time.now)
    event.finalize!
    event.status.should == "Finished"
    Event.finished.should include(event)
  end

  it "should be able to create notifications" do
    event = Event.create(name: 'Test Event', event_template: @event_template, scheduled_at: Time.now)
    event.reminders.create(email: 'test@test.com')
    event.reminders.length.should be(1)
  end

  it "should not create an event if the template it's failing" do
    event_template = EventTemplate.create(name: 'wrong', template: '{{do not work: this template}}')
    event = Event.create(name: 'Test Event', event_template: event_template, scheduled_at: Time.now)
    event.persisted?.should be_false
  end

  describe "#filter_by_tags" do
    it "only returns taggables that intersect this event's tags" do
      event = Event.create(name: 'Test Event', event_template: @event_template, scheduled_at: Time.now, tag_string: "foo, bar")
      foo_card = DataCard.create(name: "Foo", tag_string: "foo, baz")
      bar_card = DataCard.create(name: "Bar", tag_string: "bar, qux")
      baz_card = DataCard.create(name: "Baz", tag_string: "baz, qux") # no matches

      event.filter_by_tags(DataCard.all).should =~ [foo_card, bar_card]
    end

    it "returns all taggables when this event has no tags" do
      event = Event.create(name: 'Test Event', event_template: @event_template, scheduled_at: Time.now, tag_string: "")
      foo_card = DataCard.create(name: "Foo", tag_string: "foo, baz")
      bar_card = DataCard.create(name: "Bar", tag_string: "bar, qux")
      baz_card = DataCard.create(name: "Baz", tag_string: "baz, qux")

      event.filter_by_tags(DataCard.all).should have(3).elements
    end
  end
end
