class Admin::TagsController < AdminController
  def index
    tags = Tag.all.map { |t| { value: t.name, name: t.name } }
    render json: tags
  end
end
