class Admin::Templates::EventsController < AdminController

  def index
    @event_template = EventTemplate.new
    @event_templates = EventTemplate.all
  end

  def edit
    @event_template = EventTemplate.find(params[:id])
  end

  def create
    @template = EventTemplate.new(params[:event_template])
    if @template.save
      flash[:notice] = "Template saved."
      redirect_to edit_admin_templates_event_path(@template)
    else
      flash[:error] = @template.errors.full_messages.to_sentence
      redirect_to :back
    end
  end

  def update
    @template = EventTemplate.find(params[:id])
    if @template.update_attributes(params[:event_template])
      flash[:notice] = "Template updated."
      redirect_to :back
    else
      flash[:error] = @template.errors.full_messages.to_sentence
      redirect_to :back
    end
  end

  def destroy
    @template = EventTemplate.find(params[:id])
    flash[:error] = @template.errors.full_messages.to_sentence unless @template.destroy
    redirect_to admin_templates_events_path
  end

end
