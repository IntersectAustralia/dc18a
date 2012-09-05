require 'spec_helper'

describe Experiment do
  it { should respond_to(:instrument) }

  describe "Associations" do
    it { should belong_to(:user) }
    it { should belong_to(:project) }
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
    it { should ensure_length_of(:reporter_protein_text).is_at_most(255) }
    it { should ensure_length_of(:specific_dyes_text).is_at_most(255) }

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

    it 'ensures an reporter_protein_text, but only if other is true' do
      experiment = FactoryGirl.create(:experiment)
      experiment.should be_valid

      experiment.reporter_protein = true
      experiment.reporter_protein_text = "some text"
      experiment.should be_valid

      experiment.reporter_protein = true
      experiment.reporter_protein_text = ""
      experiment.should_not be_valid
    end

    it 'ensures an specific_dyes_text, but only if other is true' do
      experiment = FactoryGirl.create(:experiment)
      experiment.should be_valid

      experiment.specific_dyes = true
      experiment.specific_dyes_text = "some text"
      experiment.should be_valid

      experiment.specific_dyes = true
      experiment.specific_dyes_text = ""
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

end
