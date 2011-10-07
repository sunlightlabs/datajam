require 'spec_helper'

describe Event do
  it "creates content areas based on its event template" do

    unless SiteTemplate.first
      template_text = <<-EOT.strip_heredoc
      <html>
        <head>
          <title>Your Datajam Site</title>
        </head>

        <body>
          <h1>Your Datajam Site Title</h1>
          <div id="datajamEvent">
            <p>Nothing here yet!</p>
          </div>
        </body>

      </html>
      EOT
      SiteTemplate.create!(name: 'Site', template: template_text)
    end

    body = <<-ENDBODY
      <h1 id="datajamHeader"></h1>
      <h3 id="datajamSubheader"></h3>
      <div data-content-area="Test Content Area"></div>
    ENDBODY
    template = EventTemplate.create(name: 'Event Template', template: body)
    event = Event.create(name: 'Test Event', event_template: template)
    event.content_areas.first.name.should eql("Test Content Area")
  end
end
