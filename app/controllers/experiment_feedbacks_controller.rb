class ExperimentFeedbacksController < ApplicationController
  before_filter :authenticate_user!

  def show
  end

  def new
    # Custom authentication strategy need custom flash message
    if params[:login_id]
      if current_user.nil?
        flash[:alert] = request.env['warden'].message
      else
        flash[:notice] = request.env['warden'].message
      end
    end

    @experiment = current_user.experiments.last
    if !current_user.approved? or @experiment.nil?
      render action: :no_experiments
    else
      @experiment_feedback = @experiment.experiment_feedback || ExperimentFeedback.new
    end

  end

  def create
    @experiment = current_user.experiments.last
    @experiment_feedback = ExperimentFeedback.new(params[:experiment_feedback])
    if @experiment_feedback.save
      flash[:notice] = "Experiment feedback is saved"
      @experiment.experiment_feedback = @experiment_feedback
      @experiment.save!
      @experiment.assign_end_time
      @experiment_feedback.notify_admins_if_instrument_failed
      render action: :show
    else
      flash[:notice] = "Please fill in all mandatory fields"
      render action: :new
    end
  end

  def update
    @experiment = current_user.experiments.last
    @experiment_feedback = @experiment.experiment_feedback
    if @experiment_feedback.update_attributes(params[:experiment_feedback])
      @experiment.experiment_feedback = @experiment_feedback
      @experiment.save!
      flash[:notice] = "Experiment feedback is saved"
      @experiment.assign_end_time
      @experiment_feedback.notify_admins_if_instrument_failed
      render action: :show
    else
      flash[:notice] = "Please fill in all mandatory fields"
      render action: :new
    end
  end


  def no_experiments

  end


end