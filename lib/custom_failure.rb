class CustomFailure < Devise::FailureApp
  def redirect_url
    # custom warden strategy redirect to different url
    if params[:not_in_lab]
      scope_path
    elsif params[:login_id]
      session["#{scope}_return_to"] = root_path
      user = User.find_by_user_id(params[:login_id])
      if user.nil? and params[:controller].eql?("experiments")
        new_user_registration_path + "?login_id=#{params[:login_id]}"
      elsif user.nil? and params[:controller].eql?("experiment_feedbacks")
        pages_thank_you_path
      else
        pages_inactive_path
      end

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