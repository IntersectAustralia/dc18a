def populate_data
  load_password

  User.delete_all
  Project.delete_all
  Experiment.delete_all
  FluorescentProtein.delete_all

  create_test_users
  create_test_projects
  create_test_experiments
  create_fluorescent_proteins
end

def create_test_projects
  uid1 = User.find_by_user_id('userid4veronica').id
  uid2 = User.find_by_user_id('userid4seanl').id
  uid3 = User.find_by_user_id('userid4marc').id
  create_project(uid1, "Project A", uid1)
  create_project(uid1, "Project B", uid1)
  create_project(uid2, "Project 1", uid2)
  create_project(uid2, "Project 2", uid2)
  create_project(uid3, "Project X", uid1)
  create_project(uid3, "Project Y", uid2)
end

def create_project(uid, name, sid)
  project = Project.new(:user_id => uid, :description => "Description for #{name}", :name => name, :supervisor_id => sid, :funded_by_agency => false)
  project.save!
end

def create_test_experiments
  uid1 = User.find_by_user_id('userid4veronica').id
  uid2 = User.find_by_user_id('userid4seanl').id
  uid3 = User.find_by_user_id('userid4marc').id
  pid1 = Project.find_by_name("Project A").id
  pid2 = Project.find_by_name("Project 1").id
  pid3 = Project.find_by_name("Project X").id
  create_experiment(uid1, "Experiment 1", pid1)
  create_experiment(uid1, "Experiment 2", pid1)
  create_experiment(uid2, "Experiment 3", pid2)
  create_experiment(uid3, "Experiment 4", pid3)
end

def create_experiment(uid, name, pid)
  experiment = Experiment.new(user_id: uid,
                              project_id: pid,
                              expt_name: name,
                              lab_book_no:"#{rand(100).to_s}",
                              page_no: "#{rand(50).to_s}",
                              cell_type_or_tissue: "Type #{rand(10).to_s}",
                              expt_type: ["Fixed", "Live"][rand(2)],
                              instrument: "Populator Microscope")
  experiment.save!

end

def create_test_users
  s1 = create_supervisor(:user_id => "userid4sean", :email => "sean@intersect.org.au", :first_name => "Sean", :last_name => "McCarthy", :department => "Engineering")
  s2 = create_supervisor(:user_id => "userid4georgina", :email => "georgina@intersect.org.au", :first_name => "Georgina", :last_name => "Edwards", :department => "Engineering")
  s3 = create_administrator(:user_id => "userid4veronica", :email => "veronica@intersect.org.au", :first_name => "Veronica", :last_name => "Luke", :department => "Engineering")
  s4 = create_supervisor(:user_id => "userid4marc", :email => "marc@intersect.org.au", :first_name => "Marc", :last_name => "Ziani de F", :department => "Engineering")
  s5 = create_supervisor(:user_id => "userid4diego", :email => "diego@intersect.org.au", :first_name => "Diego", :last_name => "Alonso de Marcos", :department => "Engineering")
  s6 = create_supervisor(:user_id => "userid4shuqian", :email => "shuqian@intersect.org.au", :first_name => "Shuqian", :last_name => "Hon", :department => "Engineering")
  a1 = create_administrator(:user_id => "userid4seanl", :email => "seanl@intersect.org.au", :first_name => "Sean", :last_name => "Lin", :department => "Engineering")
  a2 = create_administrator(:user_id => "userid4kali", :email => "kali@intersect.org.au", :first_name => "Kali", :last_name => "Waterford", :department => "Engineering")

  create_unapproved([a1], :user_id => "userid4unapproved1", :email => "unapproved1@intersect.org.au", :first_name => "Unapproved", :last_name => "One", :department => "Engineering")
  create_unapproved([s1, s2], :user_id => "userid4unapproved2", :email => "unapproved2@intersect.org.au", :first_name => "Unapproved", :last_name => "Two", :department => "Engineering")
end

def create_administrator(attrs)
  admin = User.new(attrs.merge(:password => @password))
  admin.role = Role.where(:name => 'Administrator').first
  admin.activate
  admin.add_supervisor(admin)
  admin.save! ? admin : nil
end

def create_supervisor(attrs)
  supervisor = User.new(attrs.merge(:password => @password))
  supervisor.role = Role.where(:name => 'Supervisor').first
  supervisor.activate
  supervisor.add_supervisor(supervisor)
  supervisor.save! ? supervisor : nil
end

def create_unapproved(supervisors, attrs)
  unapproved = User.new(attrs.merge(:password => @password))
  supervisors.each do |s|
    unapproved.add_supervisor(s)
  end
  unapproved.save! ? unapproved : nil
end

def load_password
  password_file = File.expand_path("#{Rails.root}/tmp/env_config/sample_password.yml", __FILE__)
  if File.exists? password_file
    puts "Using sample user password from #{password_file}"
    password = YAML::load_file(password_file)
    @password = password[:password]
    return
  end

  if Rails.env.development?
    puts "#{password_file} missing.\n" +
         "Set sample user password:"
          input = STDIN.gets.chomp
          buffer = Hash[:password => input]
          Dir.mkdir("#{Rails.root}/tmp", 0755) unless Dir.exists?("#{Rails.root}/tmp")
          Dir.mkdir("#{Rails.root}/tmp/env_config", 0755) unless Dir.exists?("#{Rails.root}/tmp/env_config")
          File.open(password_file, 'w') do |out|
            YAML::dump(buffer, out)
          end
    @password = input
  else
    raise "No sample password file provided, and it is required for any environment that isn't development\n" +
              "Use capistrano's deploy:populate task to generate one"
  end

end

