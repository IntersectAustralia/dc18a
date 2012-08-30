Warden::Strategies.add(:by_ip_and_windows_login) do
  def valid?
    # code here to check whether to try and authenticate using this strategy;
    params[:ip] && params[:login_id]
  end

  def authenticate!
    # code here for doing authentication;
    ip = params[:ip]
    user = User.find_by_user_id(params[:login_id])

    # TODO which way to store the ip - instrument map?
    if user && ip == "172.16.4.78"
      # if successful, call
      success!(user) # where resource is the whatever you've authenticated, e.g. user;
      redirect!('/experiments/new', :first_name => user.first_name, :last_name => user.last_name, :signed_in => "true")
      throw :warden
    else
      # if fail, call
      fail!(message) # where message is the failure message
      redirect!('/users/sign_up', :not_exist => "true")
      throw :warden
    end
  end
end
