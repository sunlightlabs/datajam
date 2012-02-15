class NotificationMailer < ActionMailer::Base
  default from: ENV['EMAIL_REMINDERS_FROM'] || "reminder@datajam.org"

  def event_reminder(event, reminder)
    @event = event
    mail(:to => reminder.email, :subject => "#{event.name} will start shortly!")
    reminder.sent!
  end
end
