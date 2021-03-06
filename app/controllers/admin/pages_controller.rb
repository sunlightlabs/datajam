class Admin::PagesController < AdminController
  def index
    @pages = filter_and_sort Page.all.order(:slug => :desc)
    @page = Page.new
    render_if_ajax 'admin/pages/_table'
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
    check_for_errors_and_redirect(page, "deleted")
  end

  private

  def check_for_errors_and_redirect(page, message)
    if page.errors.any?
      flash[:error] = page.errors.full_messages.to_sentence
    else
      flash[:success] = "Page #{message}."
    end
    redirect_to admin_pages_path
  end
end
