class UpdateWindow
  include Mongoid::Document
  include Mongoid::Timestamps

  belongs_to :event
  belongs_to :previous_window, class_name: 'UpdateWindow', inverse_of: :next_window
  has_one :next_window, class_name: 'UpdateWindow', inverse_of: :previous_window
  embeds_many :content_updates

  protected

end
