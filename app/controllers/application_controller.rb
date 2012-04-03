class ApplicationController < ActionController::Base
  protect_from_forgery
  layout :set_layout

  private
  def pjax_request?
    !!request.headers['X-PJAX']
  end

  def set_layout
    pjax_request? ? false : "application"
  end

  def render_if_pjax(*args)
    render *args if pjax_request?
  end
end
