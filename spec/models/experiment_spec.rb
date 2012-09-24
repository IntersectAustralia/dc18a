require 'spec_helper'

describe Experiment do
  it { should respond_to(:instrument) }

  describe "Associations" do
    it { should belong_to(:user) }
    it { should belong_to(:project) }
    it { should belong_to(:experiment_feedback) }
  end

  describe "Validations" do
    it { should validate_presence_of(:expt_name) }
    it { should validate_presence_of(:lab_book_no) }
    it { should validate_presence_of(:page_no) }
    it { should validate_presence_of(:cell_type_or_tissue) }
    it { should validate_presence_of(:expt_type) }
    it { should ensure_length_of(:expt_name).is_at_most(255) }
    it { should ensure_length_of(:lab_book_no).is_at_most(255) }
    it { should ensure_length_of(:page_no).is_at_most(255) }
    it { should ensure_length_of(:cell_type_or_tissue).is_at_most(255) }
    it { should ensure_length_of(:other_text).is_at_most(255) }

    it 'ensures an other_text, but only if other is true' do
      experiment = FactoryGirl.create(:experiment)
      experiment.should be_valid

      experiment.other = true
      experiment.other_text = "some text"
      experiment.should be_valid

      experiment.other = true
      experiment.other_text = ""
      experiment.should_not be_valid
    end

    it 'ensures a fluorescent_protein_ids, but only if other is true' do
      experiment = FactoryGirl.create(:experiment)

      experiment.should be_valid

      experiment.has_fluorescent_proteins = true
      experiment.fluorescent_proteins << FactoryGirl.create(:fluorescent_protein)
      experiment.should be_valid

      experiment.has_fluorescent_proteins = true
      experiment.fluorescent_protein_ids = []
      experiment.should_not be_valid
    end

    it 'ensures an specific_dyes_text, but only if other is true' do
      experiment = FactoryGirl.create(:experiment)
      experiment.should be_valid

      experiment.has_specific_dyes = true
      experiment.specific_dyes << FactoryGirl.create(:specific_dye)
      experiment.should be_valid

      experiment.has_specific_dyes = true
      experiment.specific_dye_ids = []
      experiment.should_not be_valid
    end
  end

  describe "Experiment ID assignment" do
    it 'assigns experiment ID according to the number of experiments in the Project' do
      project1 = FactoryGirl.create(:project)
      project2 = FactoryGirl.create(:project)
      experiment1 = FactoryGirl.create(:experiment, :project => project1)
      experiment2 = FactoryGirl.create(:experiment, :project => project1)
      experiment3 = FactoryGirl.create(:experiment)
      experiment4 = FactoryGirl.create(:experiment, :project => project1)
      experiment5 = FactoryGirl.create(:experiment, :project => project2)

      experiment1.expt_id.should eq 1
      experiment2.expt_id.should eq 2
      experiment3.expt_id.should eq 1
      experiment4.expt_id.should eq 3
      experiment5.expt_id.should eq 1
    end
  end

  describe "Assign End Time" do
    it "assigns experiment end time to current time" do
      experiment = FactoryGirl.create(:experiment)
      experiment.assign_end_time
      experiment.end_time.should_not eq nil
    end
  end

  describe "Experiment Duration" do
    it 'calculates the duration of the experiment from created time to end time' do
      experiment = FactoryGirl.create(:experiment)
      experiment.created_at = DateTime.tomorrow.strftime('%Y-%m-%d %H:%M')
      experiment.end_time = (DateTime.tomorrow + 1.55).strftime('%Y-%m-%d %H:%M')
      dur = experiment.expt_duration
      dur[:diff].should eq "1 day and 13:12:00"
    end
  end

end
