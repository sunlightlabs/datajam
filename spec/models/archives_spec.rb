require "spec_helper"

describe Archives do
  before do
    @event_template = EventTemplate.create(name: 'Event Template', template: <<-ENDBODY.strip_heredoc)
      <div>The Template</div>
    ENDBODY
    Event.create(name: "Finished 1", status: "Finished", event_template: @event_template)
    Event.create(name: "Upcoming", status: "Upcoming", event_template: @event_template)
    Event.create(name: "Finished 2", status: "Finished", event_template: @event_template)
  end

  subject do
    Archives.new
  end

  describe "#events" do
    it "returns only finished events" do
      subject.events.should have(2).elements
    end

    it "returns the names and slugs of each event" do
      subject.events.all? do |event|
        event.should have_key(:name)
        event.should have_key(:slug)
      end
    end
  end

  describe "#render" do
    it "returns an html page with the archives" do
      doc = Nokogiri(subject.render)
      (doc / "#archives li").should have(2).elements
    end

    it "tells the user that there's nothing to be seen if no events are finished" do
      subject = Archives.new([])

      doc = Nokogiri(subject.render)
      (doc / "#archives li").should be_empty

      (doc % "p").text.should =~ /No past events/
    end
  end
end
