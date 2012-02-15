namespace :notifications do
  desc "test"
  task :send_reminders => :environment do
    SendRemindersJob.perform
  end
end
