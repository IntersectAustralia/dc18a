class CustomFailure < Devise::FailureApp
  def redirect_url
    # custom warden strategy redirect to different url
    if params[:not_in_lab]
      scope_path
    elsif params[:login_id]
      new_user_registration_path + "?login_id=#{params[:login_id]}"
    else
      if warden_message == :timeout
        flash[:timedout] = true
        attempted_path || scope_path
      else
        scope_path
      end
    end
  end
end