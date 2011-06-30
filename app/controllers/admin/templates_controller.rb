class Admin::TemplatesController < ApplicationController

  def index
    @template = Template.new
    @site_template = Template.site_template
    @templates = Template.event_templates
  end

  def show
    @template = Template.find(params[:id])
  end

  def new
    @template = Template.new
  end

  def edit
    @template = Template.find(params[:id])
  end

  def create
    @template = Template.new(params[:template])
    if @template.save
      flash[:notice] = "Template saved."
      redirect_to admin_templates_path
    else
      flash[:error] = "There was a problem creating saving the template."
      redirect_to admin_templates_path
    end
  end

  def update
    @template = Template.find(params[:id])
    if @template.update_attributes(params[:template])
      flash[:notice] = "Template updated."
      redirect_to :back
    else
      flash[:error] = "There was a problem saving the template."
      redirect_to :back
    end
  end

  def destroy
    @template = Template.find(params[:id])
    @template.destroy
    redirect_to admin_templates_path
  end

end
