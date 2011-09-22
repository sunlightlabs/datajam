class EventTemplate < Template

  has_many :events

  after_save do
    self.events.each { |e| e.save }
  end

  protected

  def update_events
    self.events.each { |e| e.save }
  end

end
