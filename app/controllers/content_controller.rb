class ContentController < ApplicationController

  def index
    render :string => "Welcome to Datajam", :layout => false
  end

  def error_404
    @template = SiteTemplate.first
    rendered_html = Handlebars.compile(@template.not_found_template).call({
        head_assets: @template.head_assets,
        body_assets: @template.body_assets
        })
    respond_to do |format|
      format.html { render :text => rendered_html, :layout => false, :content_type => "text/html" }
      format.json { render :json => { error: "Not found"}}
    end
  end

end
