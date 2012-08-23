class PagesController < ApplicationController
  def home
    @projects = current_user.projects.paginate(page: params[:page]) unless current_user.nil?
  end
end
