class Admin::TemplatesController < ApplicationController

  def index
    @templates = Template.all
    @template = Template.new
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
      previous = Template.where(template_filename: @template.template_filename)
      if previous.count > 1
        previous.first.destroy
        flash[:notice] += " Previous version deleted."
      end
      redirect_to admin_templates_path
    else
      flash[:error] = "There was a problem creating saving the file."
      redirect_to admin_templates_path
    end
  end

  def destroy
    @template = Template.find(params[:id])
    @template.destroy
    redirect_to admin_templates_path
  end

end
