class Admin::Templates::EmbedsController < AdminController

  def index
    @embed_template = EmbedTemplate.new
    @embed_templates = EmbedTemplate.all
  end

  def edit
    @embed_template = EmbedTemplate.find(params[:id])
  end

  def create
    @template = EmbedTemplate.new(params[:embed_template])
    if @template.save
      flash[:notice] = "Template saved."
      redirect_to edit_admin_templates_embed_path(@template)
    else
      flash[:error] = "There was a problem creating the template."
      redirect_to :back
    end
  end

  def update
    @template = EmbedTemplate.find(params[:id])
    if @template.update_attributes(params[:embed_template])
      flash[:notice] = "Template updated."
      redirect_to :back
    else
      flash[:error] = "There was a problem saving the template."
      redirect_to :back
    end
  end

  def destroy
    @template = EmbedTemplate.find(params[:id])
    @template.destroy
    flash[:error] = @template.errors.full_messages.to_sentence unless @template.destroy
    redirect_to admin_templates_embeds_path
  end

end
