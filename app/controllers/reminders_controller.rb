class RemindersController < ApplicationController
  def create
    event = Event.find(params[:event_id])
    if event
      reminder = event.reminders.create(email: params[:email])
      result = if reminder.valid?
        { message: "#{params[:email]} will be reminded before the event.", type: 'success' }
      else
        { message: reminder.errors.full_messages.to_sentence, type: 'error' }
      end
    else
      result = { message: 'This event does not exist', type: 'error' }
    end
    render json: result
  end
end
