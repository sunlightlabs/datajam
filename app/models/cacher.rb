class Cacher

  # Takes in an array of events. Only have one event to cache? Pass in an array with that one event.
  def self.cache_events(events)

    redis = Redis::Namespace.new(Rails.env.to_s, :redis => Redis.new)
    site_template = Nokogiri::HTML(SiteTemplate.first.template)

    # Cache all events.
    next_event = Event.upcoming.first
    events.each do |event|

      event_template = process_template(event.event_template.template, event.template_data)

      # Cache the event page.
      if site_template.at_css('#datajamEvent')
        site_template.at_css('#datajamEvent').inner_html = event_template.to_html
      end
      redis.set '/' + event.slug, site_template.to_html

      # Cache the root event if this is the next event.
      redis.set '/', site_template.to_html if event == next_event

      # Process the embeds.
      event.embed_templates.each do |embed|
        embed_template = process_template(embed.template, event.template_data)
        redis.set '/' + event.slug + '/' + embed.slug, embed_template.to_html
      end # event.embed_templates.each

    end # events.each

    # No upcoming events? Be sure to still cache the root.
    if next_event.nil?
      redis.set '/', site_template.to_html
    end
  end

  # Populate the template with the event's values.
  def self.process_template(raw_template, template_data)
    processed_template = Nokogiri::HTML(raw_template)
    unless template_data.nil?
      # Grab all the elements that have id=datajamXxx
      processed_template.css('[id*=datajam]').each do |el|
        # Extract the name of the field
        field = el["id"].gsub!('datajam','')
        # Fill in the event's value for that element
        el.content = template_data[field]
      end
    end
    processed_template
  end

end
