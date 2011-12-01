class UpdateWindow
  include Mongoid::Document
  include Mongoid::Timestamps

  belongs_to :event
  has_one :previous_window, class_name: 'UpdateWindow'
  has_one :next_window, class_name: 'UpdateWindow'
  embeds_many :content_updates

  before_save :enforce_max_size

  MAX_SIZE = 20

  protected

  def enforce_max_size

    if self.content_updates.length >= MAX_SIZE

      # Create a new update window and add the extraneous content updates to it.
      new_window = UpdateWindow.create(event: self.event, previous_window: self)
      new_window.content_updates << self.content_updates[MAX_SIZE, self.content_updates.length]
      new_window.save

      # Update the event's current window.
      self.event.current_window = new_window
      self.event.save

      # Update the current update window.
      self.content_updates = self.content_updates[0, MAX_SIZE]
      self.next_window = new_window

    end
  end

end
