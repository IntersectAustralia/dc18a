def populate_data
  load_password

  User.delete_all

  create_test_users
end

def create_test_users
  s1 = create_supervisor(:user_id => "userid4sean", :email => "sean@intersect.org.au", :first_name => "Sean", :last_name => "McCarthy", :department => "Engineering")
  s2 = create_supervisor(:user_id => "userid4georgina", :email => "georgina@intersect.org.au", :first_name => "Georgina", :last_name => "Edwards", :department => "Engineering")
  s3 = create_supervisor(:user_id => "userid4veronica", :email => "veronica@intersect.org.au", :first_name => "Veronica", :last_name => "Luke", :department => "Engineering")
  s4 = create_supervisor(:user_id => "userid4marc", :email => "marc@intersect.org.au", :first_name => "Marc", :last_name => "Ziani de F", :department => "Engineering")
  s5 = create_supervisor(:user_id => "userid4diego", :email => "diego@intersect.org.au", :first_name => "Diego", :last_name => "Alonso de Marcos", :department => "Engineering")
  s6 = create_supervisor(:user_id => "userid4shuqian", :email => "shuqian@intersect.org.au", :first_name => "Shuqian", :last_name => "Hon", :department => "Engineering")
  a1 = create_administrator(:user_id => "userid4seanl", :email => "seanl@intersect.org.au", :first_name => "Sean", :last_name => "Lin", :department => "Engineering")

  create_unapproved([a1], :user_id => "userid4unapproved1", :email => "unapproved1@intersect.org.au", :first_name => "Unapproved", :last_name => "One", :department => "Engineering")
  create_unapproved([s1, s2], :user_id => "userid4unapproved2", :email => "unapproved2@intersect.org.au", :first_name => "Unapproved", :last_name => "Two", :department => "Engineering")
end

def create_administrator(attrs)
  admin = User.new(attrs.merge(:password => @password))
  admin.role = Role.where(:name => 'Administrator').first
  admin.activate
  admin.save! ? admin : nil
end

def create_supervisor(attrs)
  supervisor = User.new(attrs.merge(:password => @password))
  supervisor.role = Role.where(:name => 'Supervisor').first
  supervisor.activate
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

