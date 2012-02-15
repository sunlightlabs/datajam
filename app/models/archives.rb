class Archives
  attr :events

  # Convenience method to render the archives.
  def self.render
    new.render
  end

  def initialize(events=Event.finished.all)
    @events = prepare_events_for_rendering(events)
  end

  def render
    # FIXME: Black magic, but somehow this works, while:
    #
    # body = Template.new(template: self.class.template).render_with(events: events)
    # SiteTemplate.first.render_with(content: body, head_assets: HEAD_ASSETS, body_assets: BODY_ASSETS)
    #
    # Fails with a javascript error inside Handlebars' V8 implementation.
    Handlebars.compile(SiteTemplate.first.template).call(
      content: Handlebars.compile(self.class.template).call(events: events),
      head_assets: HEAD_ASSETS,
      body_assets: BODY_ASSETS
    )
  end

  private

  def self.template
    <<-EOT.strip_heredoc
    <h2>Archives</h2>
    {{#if events}}
      <ol id="archives">
      {{#each events}}
        <li class="event">
          <a href="/{{ slug }}">{{ name }}</a>
        </li>
      {{/each}}
      </ol>
    {{else}}
      <p>No past events to show here</p>
    {{/if}}
    EOT
  end

  def prepare_events_for_rendering(events)
    events.map { |ev| { name: ev.name, slug: ev.slug } }
  end
end
