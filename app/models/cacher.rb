class Cacher

  def self.redis
    @@redis ||= Redis::Namespace.new(Rails.env.to_s, :redis => REDIS)
  end

  def self.reset!
    redis.keys.map {|key| redis.del key }
    cache_events(Event.all)
    cache_archives
    cache_pages
  end

  # Takes in an array of events. Only have one event to cache? Pass in an array with that one event.
  def self.cache_events(events)
    site_template = SiteTemplate.first

    # Cache all events.
    next_event = Event.upcoming.first
    events.each do |event|

      # Cache the event JSON.
      redis.set '/event/' + event.id.to_s + '.json', event.to_json

      # Cache the event page.
      redis.set '/' + event.slug, event.cache_render

      # Cache the root event if this is the next event.
      redis.set '/', event.render if event == next_event

      # Cache the embeds.
      event.rendered_embeds.each do |slug, embed|
        redis.set '/' + event.slug + '/' + slug, embed
      end
    end # events.each

    # No upcoming events? Be sure to still cache the root.
    if next_event.nil?
      redis.set '/', site_template.render_with(
        content: '<h2>No upcoming events</h2>',
        head_assets: HEAD_ASSETS,
        body_assets: BODY_ASSETS
      )
    end
  end

  # Stores the archives in the cache
  def self.cache_archives
    cache("/archives", Archives.render)
  end

  def self.cache_pages
    Page.all.each(&:save!)
  end

  # Convenience wrapper to write content to Redis.
  def self.cache(path, content)
    # Add a leading slash if it's not there.
    path = '/' + path if path[0] != '/'

    # Write to Redis.
    redis.set path, content
  end

  # Cleans a cached content
  def self.clean(path)
    path = '/' + path if path[0] != '/'
    redis.del path
  end

  def self.keys
    redis.keys.sort
  end

  def self.info
    redis.info.keep_if do |key, value|
      [
        'redis_version',
        'uptime_in_seconds',
        'connected_clients',
        'used_memory_human',
        'changes_since_last_save',
        'last_save_time',
        'expired_keys',
        'keyspace_hits',
        'keyspace_misses'
      ].include?(key)
    end
  end

  def self.timestamp
    redis.lastsave
  end
end
