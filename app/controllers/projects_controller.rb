class ProjectsController < ApplicationController
  helper_method :sort_column, :sort_direction

  before_filter :authenticate_user!

  load_resource

  def show
    @project = Project.find_by_id(params[:id])
    @experiments =  @project.experiments.order(sort_column + " " + sort_direction).paginate(page: params[:page]) unless @project.nil?
  end

  def new
    @project = Project.new
  end

  def create
    @project = Project.create(params[:project].merge(:user_id => current_user.id))

    if @project.save
      flash[:notice] = "Project created."
      redirect_to root_path
    else
      flash[:alert] = "Please fill in all mandatory fields."
      render 'new'
    end
  end

  def cancel
    flash[:alert] = "Project was not created."
    redirect_to root_path
  end

  def project_data
     project = Project.find_by_id(params[:id])
     render :json => project.to_json_data
  end

  def summary

  end

  private

  def sort_column
    Experiment.column_names.include?(params[:sort]) ? params[:sort] : "expt_name"
  end

  def sort_direction
    %w[asc desc].include?(params[:direction]) ? params[:direction] : "asc"
  end
end
