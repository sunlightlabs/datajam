class EmbedTemplate < Template

  has_and_belongs_to_many :events

  after_save do
    self.events.each { |e| e.save }
  end

end
