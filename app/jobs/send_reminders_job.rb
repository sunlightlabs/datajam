module SendRemindersJob
  NOTIFY_TIME_BEFORE_EVENT = Time.now + 1.hour

  def self.perform
    Event.all.where(status: 'Upcoming', :scheduled_at.gt => Time.now).and(:scheduled_at.lt => NOTIFY_TIME_BEFORE_EVENT).each do |event|
      puts "Notifications for: " + event.name if event.reminders.any?
      event.reminders.each do |reminder|
        puts "  -> Sending event reminder to: " + reminder.email
        NotificationMailer.event_reminder(event, reminder).deliver
      end
    end
  end
end
