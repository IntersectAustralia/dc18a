class PagesController < ApplicationController
  helper_method :sort_column, :sort_direction

  def home
    @projects = current_user.projects.reorder(sort_column + " " + sort_direction).paginate(page: params[:page]) unless current_user.nil?
  end

  private

  def sort_column
    Project.column_names.include?(params[:sort]) ? params[:sort] : "name"
  end

  def sort_direction
    %w[asc desc].include?(params[:direction]) ? params[:direction] : "asc"
  end
end
