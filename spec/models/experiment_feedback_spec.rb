require 'spec_helper'

describe ExperimentFeedback do

  describe "Validations" do

    it 'ensures instrument_failed_reason, but only if instrument_failed is true' do
      feedback = FactoryGirl.create(:experiment_feedback)
      feedback.should be_valid

      feedback.instrument_failed = true
      feedback.instrument_failed_reason = ""
      feedback.should_not be_valid

      feedback.instrument_failed = false
      feedback.should be_valid
    end
  end
end
