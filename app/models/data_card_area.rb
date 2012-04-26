class DataCardArea < ContentArea

  field :data_cards, type: Array
  field :current_card_id, type: String

  before_save :set_cards, :set_current_card

  def current_card
    self.current_card_id ? DataCard.find(self.current_card_id) : nil
  end

  def set_cards
    self.data_cards = event.filter_by_tags(DataCard.all).map do |card|
      { id: card.id, title: card.title }
    end
  end

  def set_current_card
    unless self.data.nil? || self.data['current_card_id'].nil?
      self.current_card_id = self.data['current_card_id']
      self.html = self.render
    end
  end

  def render
    r = "<h2>Card Not Yet Selected</h2>"
    r = self.current_card.render if self.current_card
    "<div class=\"liveCard\" id=\"content_area_#{self.id}\">#{r}</div>"
  end

end
