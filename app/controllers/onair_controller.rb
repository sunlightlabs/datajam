class OnairController < ApplicationController
  protect_from_forgery :except => [:update]
  before_filter :set_cache_buster, :only => [:signed_in]

  before_filter :authenticate_user!, :except => [:signed_in]

  def signed_in
    # Set a csrf token for cache consumers. Has the positive side-effect of starting a session as well.
    token = form_authenticity_token
    render json: { signedIn: current_user ? true : false, csrfToken: token }
  end

  def update
    event = Event.find(params.delete(:event_id))
    event.add_content_update(params)

    if event.current_window.save
      render json: { msg: 'Success updating' }
    else
      render json: { msg: 'Problem creating content update' }
    end
  end

  protected

  def set_cache_buster
    response.headers["Cache-Control"] = "no-cache, no-store, max-age=0, must-revalidate"
    response.headers["Pragma"] = "no-cache"
    response.headers["Expires"] = "Fri, 01 Jan 1990 00:00:00 GMT"
  end

end
