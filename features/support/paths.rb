module NavigationHelpers
  # Maps a name to a path. Used by the
  #
  #   When /^I go to (.+)$/ do |page_name|
  #
  # step definition in web_steps.rb
  #
  def path_to(page_name)
    case page_name

      when /^the home\s?page$/
        '/'

      when /the inactive page/
        pages_inactive_path

      when /the thank you page/
        pages_thank_you_path

      # User paths
      when /the login page/
        new_user_session_path

      when /the logout page/
        destroy_user_session_path

      when /the user profile page/
        users_profile_path

      when /the request account page/
        new_user_registration_path

      when /the reject reason page/
        reject_reason_user_path

      when /the edit my details page/
        edit_user_registration_path

      when /^the user details page for (.*)$/
        user_path(User.where(:user_id => $1).first)

      when /^the edit role page for (.*)$/
        edit_role_user_path(User.where(:user_id => $1).first)

      when /^the reset password page$/
        edit_user_password_path

      # Users paths
      when /the access requests page/
        access_requests_users_path

      when /the list users page/
        users_path

      when /the create experiment page/
        new_experiment_path

      when /the view project page for "(.*)"$/
        project_path(Project.where(:name => $1).first)

      when /the feedback page/
        new_experiment_feedback_path

      when /the view experiment page for "(.*)"$/
        experiment_path(Experiment.where(:expt_name => $1).first)

      when /the edit footer text page$/
        edit_editor_path(Editor.find_by_name("footer").id)

      # Add more mappings here.
      # Here is an example that pulls values out of the Regexp:
      #
      #   when /^(.*)'s profile page$/i
      #     user_profile_path(User.find_by_login($1))

      else
        begin
          page_name =~ /^the (.*) page$/
          path_components = $1.split(/\s+/)
          self.send(path_components.push('path').join('_').to_sym)
        rescue NoMethodError, ArgumentError
          raise "Can't find mapping from \"#{page_name}\" to a path.\n" +
                    "Now, go and add a mapping in #{__FILE__}"
        end
    end
  end
end

World(NavigationHelpers)
