class Page
  include Mongoid::Document
  include Mongoid::Slug
  include RendersTemplates

  field :slug
  field :content, type: String
  field :rendered_content, type: String

  slug :slug, permanent: true

  validates :content, presence: true
  validates :slug, uniqueness: true, presence: true, unique_slug: true

  before_save :content_wrapper, :check_slug_change
  after_save :set_route
  after_destroy :clean_route

  private

  def check_slug_change
    if !self.new_record? && self.slug_changed?
      clean_route(self.slug_was)
      set_route
    end
  end

  def content_wrapper
    self.rendered_content = SiteTemplate.first.render_with({
      content: self.content,
      head_assets: head_assets,
      body_assets: body_assets
    })
    self.rendered_content = add_body_class_to(self.rendered_content, 'page')
  end

  def set_route
    Cacher.cache self.slug, self.rendered_content
  end

  def clean_route(slug = self.slug)
    Cacher.clean slug
  end

end
