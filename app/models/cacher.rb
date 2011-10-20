class Cacher

  # Takes in an array of events. Only have one event to cache? Pass in an array with that one event.
  def self.cache_events(events)

    redis = Redis::Namespace.new(Rails.env.to_s, :redis => Redis.new)
    site_template = SiteTemplate.first.template

    # Cache all events.
    next_event = Event.upcoming.first
    events.each do |event|

      # Build the page
      event_template = Handlebars.compile(event.event_template.template).call(event.template_data)
      event_page = Handlebars.compile(site_template).call({ content: event_template })

      # Cache the event page.
      redis.set '/' + event.slug, event_page

      # Cache the root event if this is the next event.
      redis.set '/', event_page if event == next_event

      # Process the embeds.
      event.embed_templates.each do |embed|
        embed_page = Handlebars.compile(embed.template).call(event.template_data)
        redis.set '/' + event.slug + '/' + embed.slug, embed_page
      end # event.embed_templates.each

    end # events.each

    # No upcoming events? Be sure to still cache the root.
    if next_event.nil?
      redis.set '/', Handlebars.compile(site_template).call({ content: '<h2>No upcoming events</h2>' })
    end
  end

end
