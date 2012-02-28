module ApplicationHelper

  def after_sign_in_path_for(resource)
    admin_path
  end

  def after_sign_out_path_for(resource)
    admin_path
  end

  def flash_messages
    return if !flash.any?
    flash.each do |type, msg|
      type = 'error'    if type == :alert
      type = 'success'  if type == :notice
      return content_tag :div, msg, class: "alert alert-#{type}"
    end

  def next_reset
    User.first.created_at + 1.hour
  end
end
