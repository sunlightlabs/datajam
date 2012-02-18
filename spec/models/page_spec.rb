require 'spec_helper'

describe Page do
  before do
    @html = <<-BODY
      <!DOCTYPE HTML>
      <html lang="en">
        <head>
          <meta charset="UTF-8">
          <title></title>
        </head>
        <body></body>
      </html>
    BODY
  end

  it "should be created correctly" do
    page = Page.create(slug: 'about-us', content: @html)
    page.valid?.should be_true
  end

  it "should be unique among app routes" do
    page = Page.create(slug: 'users/sign_in', content: @html)
    page.valid?.should be_false
  end

  it "should be unique even with events" do
    event_template = EventTemplate.create(name: 'Event Template', template: @html)

    event = Event.create(name: 'test', event_template: event_template)
    page = Page.create(slug: 'test', content: @html)
    page2 = Page.create(slug: 'test', content: 'other')

    event.valid?.should be_true
    page.valid?.should be_false
    page2.valid?.should be_false
  end

end
