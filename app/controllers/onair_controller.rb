class OnairController < ApplicationController
  protect_from_forgery :except => :update
  before_filter :authenticate_user!, :except => [:signed_in]

  def signed_in
    render json: { signedIn: current_user ? true : false }
  end

  def update
    if ContentUpdate.create(params)
      render json: { msg: 'Success updating' }
    else
      render json: { msg: 'Problem creating content upate' }
    end
  end

end
