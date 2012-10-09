class UpdateWindow
  include Mongoid::Document
  include Mongoid::Timestamps

  belongs_to :event
  belongs_to :previous_window, class_name: 'UpdateWindow', inverse_of: :next_window
  has_one :next_window, class_name: 'UpdateWindow', inverse_of: :previous_window
  embeds_many :content_updates

  # make sure there's a content_updates array b/c mongoid doesn't
  def as_json(options = {})
    hsh = super
    hsh.merge!(content_updates: []) unless content_updates.any?
    hsh
  end

  protected

end
