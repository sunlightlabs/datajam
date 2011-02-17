class ContentController < ApplicationController

  def index
    render :string => "Welcome to Datajam", :layout => false
  end

end
