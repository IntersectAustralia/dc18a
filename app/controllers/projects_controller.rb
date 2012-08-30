class ProjectsController < ApplicationController
  before_filter :authenticate_user!

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
end
