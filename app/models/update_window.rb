class UpdateWindow
  include Mongoid::Document
  include Mongoid::Timestamps

  belongs_to :event
  has_one :previous_window, class_name: 'UpdateWindow'
  has_one :next_window, class_name: 'UpdateWindow'
  embeds_many :content_updates

  protected

end
