class Admin::PagesController < AdminController
  def index
    @pages = Page.all
    @page = Page.new
  end

  def show
    @page = Page.find_by_slug(params[:id])
  end

  def create
    page = Page.create(params[:page])
    check_for_errors_and_redirect(page, "created")
  end

  def update
    page = Page.find_by_slug(params[:id])
    page.update_attributes(params[:page])
    check_for_errors_and_redirect(page, "updated")
  end

  def destroy
    page = Page.find_by_slug(params[:id])
    page.destroy
    redirect_to admin_pages_path
  end

  private

  def check_for_errors_and_redirect(page, message)
    if page.errors.any?
      flash[:error] = page.errors.full_messages.to_sentence
    else
      flash[:notice] = "Page #{message}."
    end
    redirect_to admin_pages_path
  end
end
