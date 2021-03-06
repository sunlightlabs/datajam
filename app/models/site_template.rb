class SiteTemplate < Template
  include RendersTemplates

  field :not_found_template, type: String, default: "<h1>Page Not Found</h1>"

  def self.model_name
    # Play nice with the admin's URLs
    ActiveModel::Name.new(self, nil, "Templates::Site")
  end

  before_validation :only_one, :on => :create

  after_create do
    # Make sure there's always an /archives page
    Cacher.cache_archives
  end

  after_save do
    Event.all.each { |e| e.save }
  end

  def name_is_editable?
    false
  end

  protected

  def only_one
    self.errors.add :base, "Only one SiteTemplate can be created" if SiteTemplate.all.count > 0
  end

end
