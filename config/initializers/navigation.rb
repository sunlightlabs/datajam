module Datajam
  def self.navigation
    @@navigation ||= []
  end
end

require File.expand_path('../../navigation', __FILE__)
