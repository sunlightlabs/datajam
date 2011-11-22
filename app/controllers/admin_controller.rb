class AdminController < ApplicationController

  before_filter :authenticate_user!

  def index

  end

  def plugins
    @plugins = Datajam.plugins.sort {|x,y| x.name <=> y.name }
  end

end
