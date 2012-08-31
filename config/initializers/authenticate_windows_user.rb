require 'devise/strategies/authenticatable'

module Devise
  module Strategies
    class AuthenticateWindowsUser < Authenticatable
      def valid?
        # code here to check whether to try and authenticate using this strategy;
        params[:ip] && params[:login_id]
      end

      def authenticate!
        # code here for doing authentication;
        ip = params[:ip]
        login_id = params[:login_id]
        user = User.find_by_user_id(login_id)

        # TODO which way to store the ip - instrument map?
        if user && ip == "172.16.4.78"
          # if successful, call
          message = "Welcome #{user.full_name}."
          success!(user, message) # where resource is the whatever you've authenticated, e.g. user;
        else
          # if fail, call
          message = "You have not registered a user account Microbial Imaging facility. Please fill in the following details and register an account now. You will not be allowed to gain access until your account has been approved by the administrator."
          fail!(message) # where message is the failure message
          throw :warden
        end
      end
    end
  end
end

Warden::Strategies.add(:authenticate_windows_user, Devise::Strategies::AuthenticateWindowsUser)
