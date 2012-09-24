class ExperimentFeedbacksController < ApplicationController
  before_filter :authenticate_user!

  def show
  end

  def new
    @experiment = current_user.experiments.last
    # delete any previously assigned feedback
    @experiment.experiment_feedback.delete
    @experiment_feedback = ExperimentFeedback.new
  end

  def create
    @experiment = current_user.experiments.last
    # create new feedback
    @experiment_feedback = ExperimentFeedback.create(params[:experiment_feedback])
    #@experiment_feedback.experiment_id = @experiment.id
    @experiment.experiment_feedback = @experiment_feedback
    @experiment.save!
    if @experiment_feedback.save
      flash[:notice] = "Experiment feedback is saved"
      @experiment.assign_end_time
      @experiment_feedback.notify_admins_if_instrument_failed
      render action: :show
    else
      flash[:notice] = "Please fill in all mandatory fields"
      render action: :new
    end
  end


end