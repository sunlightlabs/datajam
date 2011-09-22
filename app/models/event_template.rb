class EventTemplate < Template

  has_many :events

  def after_update
    self.events.each { |e| e.save }
    Cacher.cache_events(self.events)
    logger.debug "Called Cacher from EventTemplate"
  end

  protected

  def update_events
    self.events.each { |e| e.save }
  end

end
