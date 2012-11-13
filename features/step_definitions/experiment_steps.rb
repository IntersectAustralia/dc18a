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

And /^The experiment "([^"]*)" is not finished$/ do |expt_name|
  Experiment.find_by_expt_name(expt_name).end_time = nil
end

And /^The experiment "([^"]*)" is finished$/ do |expt_name|
  Experiment.find_by_expt_name(expt_name).assign_end_time
end
