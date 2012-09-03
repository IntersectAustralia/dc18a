

#| owner       | project_name | description | funded_by_agency | funded_by | supervisor     |
#| userid4raul | Project A    | Some desc A | false            |           | userid4seanlin |
#| userid4raul | Project B    | Some desc B | true             | NHMRC     | userid4veronica|

And /^I have projects$/ do |table|
  table.hashes.each do |attributes|
    user = User.find_by_user_id attributes['owner']
    supervisor = User.find_by_user_id attributes['supervisor']
    FactoryGirl.create(:project, :name => attributes['project_name'], :description => attributes['description'],
                       :funded_by_agency => attributes['funded_by_agency'], :agency => attributes['funded_by'],
                       :user => user, :supervisor => supervisor)
  end
end