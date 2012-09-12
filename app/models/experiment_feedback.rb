class ExperimentFeedback < ActiveRecord::Base
  belongs_to :experiment

  attr_accessible :experiment_failed, :instrument_failed, :instrument_failed_reason, :other_comments

  validates_presence_of :experiment_failed
  validates_presence_of :instrument_failed
  validates_presence_of :instrument_failed_reason, :if => :instrument_failed?, :message => "You must specify an instrument failure reason if the instrument failed."


  def to_json_data(success)
    { "success" => success }
  end
end
