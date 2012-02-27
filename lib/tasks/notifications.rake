namespace :notifications do
  desc "Send email reminders to the notification queue for the next upcoming event"
  task :send_reminders => :environment do
    SendRemindersJob.perform
  end
end
