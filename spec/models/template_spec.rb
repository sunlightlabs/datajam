require 'spec_helper'

describe Template do

  it "parses the template for datajam* elements" do

    body = <<-ENDBODY
      <html>
        <body>
          <h1 id="datajamHeader"></h1>
          <h3 id="datajamSubheader"></h3>
        </body>
      </html>
    ENDBODY

    @template = Template.create(name: 'Test Event', template: body)
    @template.custom_fields.should eql(['Header','Subheader'])
  end

end
