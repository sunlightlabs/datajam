class UpdateWindow
  include Mongoid::Document
  include Mongoid::Timestamps

  belongs_to :event
  has_one :previous_window, class_name: 'UpdateWindow'
  has_one :next_window, class_name: 'UpdateWindow'
  embeds_many :content_updates

  after_save :save_event, :write_cache

  protected

  def save_event
    #self.event.save
  end

  def write_cache
    #Cacher.cache('/event/' + self.event.id.to_s + '/updates.json', self.to_json)
  end

end
