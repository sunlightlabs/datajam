require 'spec_helper'

describe ContentArea do

  it "sets area type based on the class name" do
    ca = ContentArea.create(name: 'Some Area')
    ca.area_type.should eql('content_area')
  end

  it "sets area type based on the subclassed class name" do
    class LiveChat < ContentArea
    end

    lc = LiveChat.create(name: 'Chat Box')
    lc.area_type.should eql('live_chat')
  end

  it "renders itself inside a div with its id set" do
    ca = ContentArea.create(name: 'Some Area', html: '<h1>Hello World</h1>')

    rendered = "<div id=\"content_area_#{ca.id}\"><h1>Hello World</h1></div>"
    ca.render.should eql(rendered)
  end

end
