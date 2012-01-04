class OnairController < ApplicationController
  protect_from_forgery :except => [:update]

  before_filter :authenticate_user!, :except => [:signed_in]

  def signed_in
    # Set a csrf token for cache consumers. Has the positive side-effect of starting a session as well.
    token = form_authenticity_token
    render json: { signedIn: current_user ? true : false, csrfToken: token }
  end

  def update
    if ContentUpdate.create(params)
      render json: { msg: 'Success updating' }
    else
      render json: { msg: 'Problem creating content upate' }
    end
  end

end
