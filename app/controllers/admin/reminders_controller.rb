class Admin::RemindersController < AdminController
  def destroy
    event = Event.find(params[:event_id])
    reminder = event.reminders.find(params[:id])
    reminder.destroy
    redirect_to edit_admin_event_path(event)
  end
end
