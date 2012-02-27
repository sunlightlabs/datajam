module SendRemindersJob
  # Task runs every hour, ensure at least 30 minutes lead time
  NOTIFY_TIME_BEFORE_EVENT = Time.now + 90.minutes

  def self.perform
    Event.all.where(status: 'Upcoming', :scheduled_at.gt => Time.now).and(:scheduled_at.lt => NOTIFY_TIME_BEFORE_EVENT).each do |event|
      puts "Notifications for: " + event.name if event.reminders.any?
      event.reminders.each do |reminder|
        unless reminder.sent?
          puts "  -> Sending event reminder to: " + reminder.email
          NotificationMailer.event_reminder(event, reminder).deliver
        end
      end
    end
  end
end
