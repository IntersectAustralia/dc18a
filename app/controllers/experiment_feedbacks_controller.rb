class ExperimentFeedbacksController < ApplicationController
  before_filter :authenticate_user!

  def show
  end

  def new
    @experiment = Experiment.find_by_id(params[:experiment_id])
    @experiment_feedback = ExperimentFeedback.new
  end

  def create
    # TODO Refactor this!! This is not the right way to do things!!!
    @experiment = Experiment.find_by_id(params[:experiment_id])
    @experiment_feedback = ExperimentFeedback.create(params[:experiment_feedback])
    @experiment_feedback.experiment_id = @experiment.id
    if @experiment_feedback.save
      flash[:notice] = "Experiment feedback is saved"
      render action: :show
    else
      flash[:notice] = "Please fill in all mandatory fields"
      render action: :new
    end
  end


end