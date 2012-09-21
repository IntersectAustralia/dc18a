class ExperimentFeedback < ActiveRecord::Base
  belongs_to :experiment

  attr_accessible :experiment_failed, :instrument_failed, :instrument_failed_reason, :other_comments

  validates_presence_of :instrument_failed_reason, :if => :instrument_failed?, :message => "You must specify an instrument failure reason if the instrument failed."

  def notify_admins_if_instrument_failed
    if self.instrument_failed?
      Notifier.notify_admins_of_instrument_failure(self).deliver
    end
  end

end
