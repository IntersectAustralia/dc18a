class PagesController < ApplicationController
  def home
    @projects = current_user.projects unless current_user.nil?
  end
end
