class Archives
  include RendersTemplates

  attr :events

  # Convenience method to render the archives.
  def self.render
    new.render
  end

  def initialize(events=Event.finished.all)
    @events = events
  end

  def render
    # FIXME: Black magic, but somehow this works, while:
    #
    # body = Template.new(template: self.class.template).render_with(events: events)
    # SiteTemplate.first.render_with(content: body, head_assets: HEAD_ASSETS, body_assets: BODY_ASSETS)
    #
    # Fails with a javascript error inside Handlebars' V8 implementation.
    Handlebars.compile(SiteTemplate.first.template).call(
      content: render_to_string(file: 'archives/index', layout: false, locals: { events: events }),
      head_assets: head_assets,
      body_assets: body_assets
    )
  end

end
