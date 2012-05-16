class Admin::Templates::SiteController < AdminController

  def show
    @site_template = SiteTemplate.first
  end

  def update
    @site_template = SiteTemplate.first
    if @site_template.update_attributes(params[:templates_site])
      flash[:success] = "Template updated."
      redirect_to :back
    else
      flash[:error] = @site_template.errors.full_messages.to_sentence
      redirect_to :back
    end
  end

end
