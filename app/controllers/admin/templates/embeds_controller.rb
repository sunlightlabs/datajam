class Admin::Templates::EmbedsController < AdminController
  before_filter :load_templates, only: [:index, :create]

  def load_templates
    @embed_templates = filter_and_sort EmbedTemplate.all
  end

  def index
    @template = EmbedTemplate.new
    render 'admin/templates/embeds/_table' if pjax_request?
  end

  def edit
    @template = EmbedTemplate.find(params[:id])
  end

  def create
    @template = EmbedTemplate.new(params[:templates_embed])
    if @template.save
      flash[:success] = "Template saved."
      redirect_to edit_admin_templates_embed_path(@template)
    else
      flash[:error] = @template.errors.full_messages.to_sentence
      render :index
    end
  end

  def update
    @template = EmbedTemplate.find(params[:id])
    if @template.update_attributes(params[:templates_embed])
      flash[:success] = "Template updated."
      redirect_to :back
    else
      flash[:error] = @template.errors.full_messages.to_sentence
      render :edit
    end
  end

  def destroy
    @template = EmbedTemplate.find(params[:id])
    if @template.destroy
      flash[:success] = "Template deleted."
    else
      flash[:error] = @template.errors.full_messages.to_sentence
    end
    redirect_to admin_templates_embeds_path
  end

end
