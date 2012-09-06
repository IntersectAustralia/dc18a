Given /^"([^"]*)" has experiments$/ do |user_id, table|
  user = User.find_by_user_id(user_id)

  table.hashes.each do |hash|
    FactoryGirl.create(:experiment, :user => user, :expt_name => hash[:name], :project => Project.find_by_name(hash[:project]), :instrument => hash[:instrument])
  end
end

Then /^I should get a download "YYYYMMDD_P<p_id>_E<e_id>_<instrument>.zip" for "([^"]*)"$/ do |e|
  experiment = Experiment.find_by_expt_name(e)
  prefix = I18n.localize(experiment.created_at, :format => :yyyymmdd)
  p_id = experiment.project.id
  e_id = experiment.expt_id
  instrument = experiment.instrument
  filename = "#{prefix}_P#{p_id}_E#{e_id}_#{instrument}.zip"
  page.response_headers['Content-Disposition'].should include("filename=\"#{filename}\"")
end

When /^I follow "([^"]*)" for project "([^"]*)"$/ do |link, proj_name|
  project = Project.find_by_name(proj_name)
  click_link("view_#{project.id}")
end

When /^I follow "Save and Download Metadata" for experiment "([^"]*)"$/ do |expt_name|
  experiment = Experiment.find_by_expt_name(expt_name)
  click_link("download_#{experiment.id}")
end
