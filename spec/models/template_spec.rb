require 'spec_helper'

describe Template do

  before(:all) do
    @body = <<-ENDBODY
      <html>
        <body>
          <h1>{{ header }}</h1>
          <h3>{{subheader}}</h3>
          {{ content_area: Video Embed }}
          {{ chat: Live Blog }}
          {{{content}}}
          {{{ body_assets }}}
        </body>
      </html>
    ENDBODY
    @template = Template.create(name: 'Test Template', template: @body)
  end

  it "uses id as to_param" do
    @template.to_param.should eql(@template.id.to_s)
  end



  it "sets custom_fields based on handlebar syntax" do

    @template.custom_fields.should eql(['header','subheader'])

  end

  it "sets custom_areas based on handlebar syntax" do

    @template.custom_areas.should eql({"Video Embed" => "content_area", "Live Blog" => "chat"})

  end

  it "renders itself when given some data" do
    body = "<h1>{{ header }}</h1>"
    template = Template.create(name: 'Test Template', template: body)

    template.render_with({"header" => "Hello World"}).should eql("<h1>Hello World</h1>")
  end

  it "should fail when a poorly written template is made" do
    body = "<h1>{{ will fail horribly </h1>"
    template = Template.create(name: 'Test Template', template: body)

    template.persisted?.should be_false
  end

end
