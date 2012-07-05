class AdminController < ApplicationController

  before_filter :authenticate_user!

  def index

  end

  def rebuild_cache
    RebuildCacheJob.perform
  end

end
