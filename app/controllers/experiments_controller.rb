class ExperimentsController < ApplicationController
  before_filter :authenticate_user!

  load_resource

  def new
    # Custom authentication strategy need custom flash message
    if params[:login_id] && params[:ip]
      if current_user.nil?
        flash[:alert] = request.env['warden'].message
      else
        flash[:notice] = request.env['warden'].message
      end
    end

    @projects = current_user.projects
    @experiment = current_user.experiments.new
  end

  def create
    @experiment = current_user.experiments.build(params[:experiment])

    if @experiment.save
      flash[:notice] = "Experiment created"
      redirect_to root_path
    else
      flash[:alert] = "Please fill in all mandatory fields"
      @projects = current_user.projects
      render action: "new"
    end
  end

  def cancel
    redirect_to root_path
  end

end
