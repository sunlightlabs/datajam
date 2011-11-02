class Cacher

  # Takes in an array of events. Only have one event to cache? Pass in an array with that one event.
  def self.cache_events(events)

    redis = Redis::Namespace.new(Rails.env.to_s, :redis => Redis.new)
    site_template = SiteTemplate.first

    # Cache all events.
    next_event = Event.upcoming.first
    events.each do |event|

      # Cache the event page.
      redis.set '/' + event.slug, event.render

      # Cache the root event if this is the next event.
      redis.set '/', event.render if event == next_event

      # Cache the embeds.
      event.rendered_embeds do |slug, embed|
        redis.set '/' + event.slug + '/' + slug, embed
      end
    end # events.each

    # No upcoming events? Be sure to still cache the root.
    if next_event.nil?
      redis.set '/', site_template.render_with({ content: '<h2>No upcoming events</h2>' })
    end
  end

  # Convenience wrapper to write content to Redis.
  def self.cache(path, content)
    redis = Redis::Namespace.new(Rails.env.to_s, :redis => Redis.new)

    # Add a leading slash if it's not there.
    path = '/' + path if path[0] != '/'

    # Write to Redis.
    redis.set path, content
  end

end
