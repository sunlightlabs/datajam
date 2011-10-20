require 'spec_helper'

describe Template do

  it "sets custom_fields based on handlebars" do

    body = <<-ENDBODY
      <html>
        <body>
          <h1>{{ header }}</h1>
          <h3>{{subheader}}</h3>
          {{content}}
        </body>
      </html>
    ENDBODY

    @template = Template.create(name: 'Test Event', template: body)
    @template.custom_fields.should eql(['header','subheader'])
  end

end
