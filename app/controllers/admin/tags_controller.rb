class Admin::TagsController < AdminController
  def index
    tags = Tag.all

    respond_to do |format|
      format.html { @tags = filter_and_sort tags }
      format.json { render json: tags.map { |t| { value: t.name, name: t.name } } }
    end
  end

  def destroy
    tag = Tag.find(params[:id])
    tag.destroy
    redirect_to :back
  end
end
