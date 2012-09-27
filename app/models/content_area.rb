class ContentArea
  include Mongoid::Document
  include Mongoid::Timestamps

  def self.modal_class
    'Datajam.views.Modal'
  end

  field :name,      type: String
  field :area_type, type: String
  field :html,      type: String
  field :data,      type: Hash,   default: {}

  embedded_in :event

  after_save :set_area_type

  def render_head
    ""
  end

  def render_body
    ""
  end

  # Renders the HTML of the content area. Override this when subclassing.
  def render
    "<div id=\"#{self.area_type}_#{self.id}\">#{self.html}</div>"
  end

  def render_update
    "#{self.html}"
  end

  def as_json(options = {})
    super.merge(:modal_class => self.class.modal_class)
  end

  # Always mark ContentAreas as dirty so that callbacks cascade properly
  def changed?
    true
  end

  protected

  # A convenience for querying by class name.
  def set_area_type
    self.area_type = self.class.to_s.underscore
  end

end
