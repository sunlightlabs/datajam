class Admin::Templates::EventsController < AdminController
  before_filter :load_templates, only: [:index, :create]

  def load_templates
    @event_templates = filter_and_sort EventTemplate.all
  end

  def index
    @template = EventTemplate.new
    render_if_ajax 'admin/templates/events/_table'
  end

  def edit
    @template = EventTemplate.find(params[:id])
  end

  def show
    redirect_to admin_templates_events_path
  end

  def create
    @template = EventTemplate.new(params[:templates_event])
    if @template.save
      flash[:success] = "Template saved."
      redirect_to edit_admin_templates_event_path(@template)
    else
      flash[:error] = @template.errors.full_messages.to_sentence
      render :index
    end
  end

  def update
    @template = EventTemplate.find(params[:id])
    if @template.update_attributes(params[:templates_event])
      flash[:success] = "Template updated."
      redirect_to :back
    else
      flash[:error] = @template.errors.full_messages.to_sentence
      render :edit
    end
  end

  def destroy
    @template = EventTemplate.find(params[:id])
    if @template.destroy
      flash[:success] = "Template deleted."
    else
      flash[:error] = @template.errors.full_messages.to_sentence
    end
    redirect_to admin_templates_events_path  
  end

end
