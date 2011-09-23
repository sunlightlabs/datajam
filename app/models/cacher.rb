class Cacher

  # Takes in an array of events. Only have one event to cache? Pass in an array with that one event.
  def self.cache_events(events)

    redis = Redis::Namespace.new(Rails.env.to_s, :redis => Redis.new)
    site_template = Nokogiri::HTML(SiteTemplate.first.template)

    # Cache all events.
    next_event = Event.upcoming.first
    events.each do |event|

      # Populate the template with the event's values.
      template = Nokogiri::HTML(event.event_template.template)
      unless event.template_data.nil?
        template.css('[id*=datajam]').each do |el|
          field = el["id"].gsub!('datajam','')
          el.content = event.template_data[field]
        end
      end

      # Cache the event page.
      site_template.at_css('#datajamEvent').inner_html = template.to_html
      redis.set '/' + event.slug, site_template.to_html

      # Cache the root event if this is the next event.
      redis.set '/', site_template.to_html if event == next_event
    end

    # No upcoming events? Be sure to still cache the root.
    if next_event.nil?
      redis.set '/', site_template.to_html
    end
  end

end
