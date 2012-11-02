class AdminController < ApplicationController
  before_filter :authenticate_user!
  after_filter :disable_strict_xss_protection

  def index

  end

  def rebuild_cache
    RebuildCacheJob.perform
  end

  def set_layout
    request.xhr? ? false : "admin"
  end

  def disable_strict_xss_protection
    response.headers['X-XSS-Protection'] = "0"
  end

end
