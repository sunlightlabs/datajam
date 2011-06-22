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

  def parse_time(e)
    e['scheduled_at'] = Chronic.parse e['scheduled_at']
    e
  end

end

