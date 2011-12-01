class ContentUpdate
  include Mongoid::Document
  include Mongoid::Timestamps

  field :content_area_id, type: String
  field :html,            type: String
  field :data,            type: Hash

  embedded_in :update_window

end
