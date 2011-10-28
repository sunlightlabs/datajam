class ContentArea
  include Mongoid::Document
  include Mongoid::Timestamps

  field :name,      type: String
  field :area_type, type: String
  field :html,      type: String
  field :template,  type: String
  field :data,      type: Hash

  belongs_to :event

  after_save :set_area_type

  # Renders the HTML of the content area. Override this when subclassing.
  def render
    "<div id=\"#{self.area_type}_#{self.id}\">#{self.html}</div>"
  end

  protected

  # A convenience for querying by class name.
  def set_area_type
    self.area_type = self.class.to_s.underscore
  end
end
