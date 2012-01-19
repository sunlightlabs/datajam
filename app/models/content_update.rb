class ContentUpdate
  include Mongoid::Document
  include Mongoid::Timestamps

  field :content_area_id, type: String
  field :html,            type: String
  field :data,            type: Hash

  embedded_in :update_window

  after_create :update_content_area

  def update_content_area
    content_area = self.update_window.event.content_areas.find(self.content_area_id)
    content_area.update_attributes(html: self.html, data: self.data)
    content_area.save

    self.html = content_area.render
    self.save
  end

end
