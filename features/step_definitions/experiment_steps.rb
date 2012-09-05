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