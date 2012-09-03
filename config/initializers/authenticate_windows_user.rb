require 'devise/strategies/authenticatable'
require 'yaml'

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

        # Read ip from ip instruments mapping configuration file, see config/initializers/0_load_dc18a_config.rb
        ip_addresses = INSTRUMENTS.keys

        if ip_addresses.include?(ip)
          if user
            # user in system and login from within lab
            message = "Welcome #{user.full_name}."
            success!(user, message) # where resource is the whatever you've authenticated, e.g. user;
          else
            # login from within lab but user not in system
            message = "You have not registered a user account with the Microbial Imaging facility. Please fill in the following details and register an account now. You will not be allowed access until your account has been approved by the administrator."
            fail!(message) # where message is the failure message
          end
        else
          # try to login from outside of lab
          params[:not_in_lab] = true
          fail!
        end
      end
    end
  end
end

Warden::Strategies.add(:authenticate_windows_user, Devise::Strategies::AuthenticateWindowsUser)