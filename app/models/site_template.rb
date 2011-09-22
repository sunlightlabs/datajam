class SiteTemplate < Template

  before_validation :only_one, :on => :create

  protected

  def only_one
    self.errors.add :base, "Only one SiteTemplate can be created" if SiteTemplate.all.count > 0
  end


  def cache_template

    redis = Redis::Namespace.new(Rails.env.to_s, :redis => Redis.new)
    site_template = Nokogiri::HTML(self.template)

    # Cache all events.
    next_event = Event.upcoming.first
    Event.all.each do |event|

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

    # No upcoming events? Be sure to still cache the update.
    if next_event.nil?
      redis.set '/', site_template.to_html
    end
  end

end
