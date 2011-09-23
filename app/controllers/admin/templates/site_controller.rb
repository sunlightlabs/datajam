class Admin::Templates::SiteController < AdminController

  def show
    @site_template = SiteTemplate.first
  end

  def update
    @site_template = SiteTemplate.first
    if @site_template.update_attributes(params[:site_template])
      flash[:notice] = "Template updated."
      redirect_to :back
    else
      flash[:error] = "There was a problem saving the template."
      redirect_to :back
    end
  end

end
