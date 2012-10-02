class Admin::TemplatesController < AdminController
  before_filter :load_templates, only: [:index]

  def load_type
    @type = params[:type] || (
      params[:templates_event] && params[:templates_event][:type] ||
      params[:templates_embed] && params[:templates_embed][:type]
    ).constantize
  end

  def load_templates
    load_type
    @templates = filter_and_sort @type.all.order(:updated_at => :desc)
  end

  def possible_params
    params[:templates_event] || params[:templates_embed] || params[:templates_site]
  end

  def index
    @template = @type.new
    render_if_ajax 'admin/templates/_table'
  end

  def show
    redirect_to admin_templates_path(@type)
  end

  def edit
    @template = Template.find(params[:id])
  end

  def create
    load_type
    @template = @type.new(possible_params)
    if @template.save
      flash[:success] = "Template saved."
    else
      flash[:error] = @template.errors.full_messages.to_sentence
    end
    redirect_to :back
  end

  def update
    @template = Template.find(params[:id])
    if @template.update_attributes(possible_params)
      flash[:success] = "Template updated."
      redirect_to :back
    else
      flash[:error] = @template.errors.full_messages.to_sentence
      render :edit
    end
  end

  def destroy
    @template = Template.find(params[:id])
    if @template.destroy
      flash[:success] = "Template deleted."
    else
      flash[:error] = @template.errors.full_messages.to_sentence
    end
    redirect_to :back
  end
end
