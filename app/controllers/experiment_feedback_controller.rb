class ExperimentFeedbackController < ApplicationController
  before_filter :authenticate_user!

  load_resource

  def new
    @experiment = Experiment.find_by_id(params[:experiment_id])
    @experiment_feedback = ExperimentFeedback.new
  end

  def create
    @experiment_feedback = @experiment.experiment_feedback.build(params[:experiment_feedback])
    if @experiment_feedback.save
      flash[:notice] = "Experiment feedback is saved"
      render :json => @experiment_feedback.to_json_data(success=true)
    else
      flash[:notice] = "Please fill in all mandatory fields"
      render :json => @experiment_feedback.to_json_data(success=false)
    end
  end

end