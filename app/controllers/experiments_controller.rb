class ExperimentsController < ApplicationController

  def new
    @projects = current_user.projects
    @experiment = current_user.experiments.new
  end

  def create
    @experiment = current_user.experiments.build(params[:experiment])

    if @experiment.save
      flash[:notice] = "Experiment created"
      redirect_to experiments_path
    else
      flash[:alert] = "Please fill in all mandatory fields"
      render 'new'
    end
  end

  def cancel
    redirect_to root_path
  end

end
