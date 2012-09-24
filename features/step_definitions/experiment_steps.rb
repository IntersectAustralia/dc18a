And /^I have projects$/ do |table|
  table.hashes.each do |attributes|
    user = User.find_by_user_id attributes['owner']
    supervisor = User.find_by_user_id attributes['supervisor']
    FactoryGirl.create(:project, :name => attributes['project_name'], :description => attributes['description'],
                       :funded_by_agency => attributes['funded_by_agency'], :agency => attributes['funded_by'],
                       :user => user, :supervisor => supervisor)
  end
end

And /^I have experiments$/ do |table|
  table.hashes.each do |attributes|
    user = User.find_by_user_id attributes['owner']
    project = Project.find_by_name attributes['project']
    FactoryGirl.create(:experiment, :expt_name => attributes['expt_name'],
                       :lab_book_no => attributes['lab_book_no'],
                       :user => user, :project => project)
  end
end

And /^I have fluorescent proteins/ do |table|
  table.hashes.each do |attributes|
    FactoryGirl.create(:fluorescent_protein, attributes)
  end
end

And /^the experiment "(.*)" should have (\d+) fluorescent proteins$/ do |exp_name, number|
  Experiment.find_by_expt_name(exp_name).fluorescent_proteins.count.should eq(number.to_i)
end

And /^there should be (\d+) fluorescent proteins$/ do |number|
  FluorescentProtein.count.should eq(number.to_i)
end

And /^the experiment "(.*)" should have (\d+) specific dyes$/ do |exp_name, number|
  Experiment.find_by_expt_name(exp_name).specific_dyes.count.should eq(number.to_i)
end

And /^there should be (\d+) specific dyes$/ do |number|
  SpecificDye.count.should eq(number.to_i)
end
