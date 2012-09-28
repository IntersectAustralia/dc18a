def create_roles_and_permissions
  Permission.delete_all
  Role.delete_all

  #TODO: create your roles here
  superuser = "Administrator"
  researcher = "Researcher"
  supervisor = "Supervisor"
  Role.create!(:name => superuser)
  Role.create!(:name => researcher)
  Role.create!(:name => supervisor)

end

