class EventTemplate < Template
  def self.model_name
    # Play nice with the admin's URLs
    ActiveModel::Name.new(self, nil, "Templates::Event")
  end

  has_many :events

  after_save do
    self.events.each { |e| e.save }
  end
end
