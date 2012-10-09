module Datajam
  def self.reserved_routes
    @@reserved_routes ||= ['admin','archives','reminders','onair','static','users']
  end
end