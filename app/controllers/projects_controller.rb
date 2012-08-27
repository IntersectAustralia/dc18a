class ProjectsController < ApplicationController
  def new
    @project = current_user.projects.new
  end

  def create
    @project = current_user.projects.build(params[:project])

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
