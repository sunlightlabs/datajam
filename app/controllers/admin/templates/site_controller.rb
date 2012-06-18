class Admin::Templates::SiteController < AdminController
  def index
    @template = SiteTemplate.first
  end

  def update
    @template = SiteTemplate.first
    if @template.update_attributes(params[:templates_site])
      flash[:success] = "Template updated."
      redirect_to :back
    else
      flash[:error] = @template.errors.full_messages.to_sentence
      redirect_to :back
    end
  end

end
