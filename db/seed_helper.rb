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

def create_fluorescent_proteins
  FluorescentProtein.create!(name: "GFP", core: true)
  FluorescentProtein.create!(name: "YFP", core: true)
  FluorescentProtein.create!(name: "CFP", core: true)
  FluorescentProtein.create!(name: "RFP", core: true)
end

def create_immunofluorescence_values
  Immunofluorescence.create!(name: "Goat anti-Rabbit IgG AF405", core: true)
  Immunofluorescence.create!(name: "Goat anti-Rabbit IgG AF488", core: true)
  Immunofluorescence.create!(name: "Goat anti-Rabbit IgG AF568", core: true)
  Immunofluorescence.create!(name: "Goat anti-Mouse IgG AF405", core: true)
  Immunofluorescence.create!(name: "Goat anti-Mouse IgG AF488", core: true)
  Immunofluorescence.create!(name: "Goat anti-Mouse IgG AF568", core: true)
  Immunofluorescence.create!(name: "Goat anti Mouse IgM AF488", core: true)
end

def cerate_footer_initial_text
  Editor.create!(name: "footer", text: "Initial footer text")
end

