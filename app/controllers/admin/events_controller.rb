class Admin::EventsController < AdminController

  def index
    @events = Event.upcoming
    @event = Event.new
    @event_templates = EventTemplate.all
    @embed_templates = EmbedTemplate.all
  end

  def show
    @event = Event.find(params[:id])
  end

  def new
    @event = Event.new
  end

  def edit
    @event = Event.find(params[:id])
    @event_templates = EventTemplate.all
    @embed_templates = EmbedTemplate.all
  end

  def create
    @event = Event.new(parse_time(params[:event]))
    if @event.save
      flash[:notice] = "Event saved."
      redirect_to admin_events_path
    else
      flash[:error] = "There were some problems saving the event: #{@event.errors.full_messages.to_sentence}"
      redirect_to admin_events_path
    end
  end

  def update
    @event = Event.find(params[:id])
    begin
      if @event.update_attributes(parse_time(params[:event]))
        flash[:notice] = "Event updated."
        redirect_to edit_admin_event_path(@event)
      else
        flash[:error] = "There was a problem saving the event."
        redirect_to edit_admin_event_path(@event)
      end
    rescue NameError
      flash[:error] = "Unable to save. Make sure to use plugins' uninstall scripts before removing them from your Gemfile."
      redirect_to edit_admin_event_path(@event)
    end
  end

  def finalize
    @event = Event.find(params[:id])
    @event.finalize!
    redirect_to :back
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

