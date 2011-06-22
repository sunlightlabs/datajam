class Admin::EventsController < ApplicationController

  def index
    @events = Event.all
    @event = Event.new
    @templates = Template.site_templates
  end

  def show
    @event = Event.find(params[:id])
  end

  def new
    @event = Event.new
  end

  def edit
    @event = Event.find(params[:id])
    @templates = Template.site_templates
  end

  def create
    @event = Event.new(parse_time(params[:event]))
    if @event.save
      flash[:notice] = "Event saved."
      redirect_to admin_events_path
    else
      flash[:error] = "There was a problem saving the event."
      redirect_to admin_events_path
    end
  end

  def update
    @event = Event.find(params[:id])
    if @event.update_attributes(parse_time(params[:event]))
      flash[:notice] = "Event updated."
      redirect_to admin_events_path
    else
      flash[:error] = "There was a problem saving the event."
      redirect_to admin_events_path
    end
  end

  def destroy
    @event = Event.find(params[:id])
    @event.destroy
    redirect_to admin_events_path
  end

  protected

  # The Rails datetime_select helper uses a funky params format to break up the timestamps.
  # Process it into a Mongo-friendly string and unset the values so Mongo doesn't save them.
  def process_timestamp(e)
    e['scheduled_at'] = "#{e['scheduled_at(1i)']}-#{e['scheduled_at(2i)']}-#{e['scheduled_at(3i)']} #{e['scheduled_at(4i)']}:#{e['scheduled_at(5i)']}"
    (1..5).each do |n|
      e.delete "scheduled_at(#{n}i)"
    end
    e
  end

  def parse_time(e)
    e['scheduled_at'] = Chronic.parse e['scheduled_at']
    e
  end

end

