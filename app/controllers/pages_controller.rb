class PagesController < ApplicationController
  helper_method :sort_column, :sort_direction

  def home
    if sort_column == "supervisor_id"
      @projects = current_user.projects.joins(:supervisor).order("users.user_id" + " " + sort_direction).paginate(page: params[:page]) unless current_user.nil?
    else
      @projects = current_user.projects.order(sort_column + " " + sort_direction).paginate(page: params[:page]) unless current_user.nil?
    end
  end

  private

  def sort_column
    Project.column_names.include?(params[:sort]) ? params[:sort] : "name"
  end

  def sort_direction
    %w[asc desc].include?(params[:direction]) ? params[:direction] : "asc"
  end
end
