class Admin::TagsController < AdminController
  def index
    tags = Tag.all

    respond_to do |format|
      format.html { @tags = filter_and_sort tags }
      format.json { render json: tags.map { |t| { value: t.name, name: t.name } } }
    end
  end

  def update
    tag = Tag.find(params[:id])
    tag.update_attributes(params[:tag])

    respond_to do |format|
      format.html do
        flash[:success] = "Tag updated."
        redirect_to :back
      end
      format.js   { render text: tag.name, status: :ok }
    end
  end

  def destroy
    tag = Tag.find(params[:id])
    tag.destroy
    flash[:success] = "Tag deleted."
    redirect_to :back
  end
end
