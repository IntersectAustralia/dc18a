#$:.unshift(File.expand_path('./lib', ENV['rvm_path']))
require 'bundler/capistrano'
require 'capistrano/ext/multistage'
require 'capistrano_colors'
require 'rvm/capistrano'

set :shared_file_dir, "files"
set(:shared_file_path) { File.join(shared_path, shared_file_dir) }

set :application, 'dc18a'
set :stages, %w(qa staging production)
set :default_stage, "qa"
set :rpms, "openssl openssl-devel curl-devel httpd-devel apr-devel apr-util-devel zlib zlib-devel libxml2 libxml2-devel libxslt libxslt-devel libffi mod_ssl mod_xsendfile"
set :shared_children, shared_children + %w(log_archive)
set :shell, '/bin/bash'
set :rvm_ruby_string, 'ruby-1.9.3-p194@dc18a'
set :rvm_type, :user

# Deploy using copy for now
set :scm, 'git'
set :repository, 'https://github.com/IntersectAustralia/dc18a.git'
set :deploy_via, :copy
set :copy_exclude, [".git/*"]

set(:user) { "#{defined?(user) ? user : 'devel'}" }
set(:group) { "#{defined?(group) ? group : user}" }
set(:user_home) { "/home/#{user}" }
set(:deploy_to) { "#{user_home}/#{application}" }

set :branch do
  require 'colorize'
  default_tag = 'HEAD'

  puts "Availible tags:".colorize(:yellow)
  puts `git tag`

  tag = Capistrano::CLI.ui.ask "Tag to deploy (make sure to push the tag first) or HEAD?: [#{default_tag}] ".colorize(:yellow)
  tag = default_tag if tag.empty?
  tag = nil if tag.eql?("HEAD")

  tag
end

default_run_options[:pty] = true

namespace :server_setup do
  task :rpm_install, :roles => :app do
    run "#{try_sudo} yum install -y #{rpms}"
  end
  namespace :filesystem do
    task :dir_perms, :roles => :app do
      run "[[ -d #{deploy_to} ]] || #{try_sudo} mkdir #{deploy_to}"
      run "#{try_sudo} chown -R #{user}.#{group} #{deploy_to}"
      run "#{try_sudo} chmod 0711 #{user_home}"
    end

    task :mkdir_db_dumps, :roles => :app do
      run "#{try_sudo} mkdir -p #{shared_path}/db_dumps"
      run "#{try_sudo} chown -R #{user}.#{group} #{shared_path}/db_dumps"
    end
  end
  namespace :rvm do
    task :trust_rvmrc do
      run "rvm rvmrc trust #{release_path}"
    end
  end
  task :gem_install, :roles => :app do
    run "gem install bundler"
    run "gem install passenger --version '3.0.18'"
  end
  task :passenger, :roles => :app do
    run "passenger-install-apache2-module -a"
  end
  namespace :config do
    task :apache do
      src = "#{release_path}/config/httpd/#{stage}_rails_#{application}.conf"
      dest = "/etc/httpd/conf.d/rails_#{application}.conf"
      run "cmp -s #{src} #{dest} > /dev/null; [ $? -ne 0 ] && #{try_sudo} cp #{src} #{dest} && #{try_sudo} /sbin/service httpd graceful; /bin/true"
    end
  end
  namespace :logging do
    task :rotation, :roles => :app do
      run "#{try_sudo} mkdir -p /var/log/httpd/archive"
      src = "#{release_path}/config/#{application}.logrotate"
      dest = "/etc/logrotate.d/#{application}"
      run "cmp -s #{src} #{dest} > /dev/null; [ $? -ne 0 ] && #{try_sudo} cp #{src} #{dest}; /bin/true"
      src = "#{release_path}/config/httpd/httpd.logrotate"
      dest = "/etc/logrotate.d/httpd"
      run "cmp -s #{src} #{dest} > /dev/null; [ $? -ne 0 ] && #{try_sudo} cp #{src} #{dest}; /bin/true"
    end
  end
end
before 'deploy:setup' do
  server_setup.rpm_install
  server_setup.rvm.trust_rvmrc
  server_setup.gem_install
  server_setup.passenger
end
after 'deploy:setup' do
  server_setup.filesystem.dir_perms
  server_setup.filesystem.mkdir_db_dumps
end
after 'deploy:update' do
  server_setup.logging.rotation
  server_setup.config.apache
  deploy.new_secret
  deploy.restart
  deploy.additional_symlinks
  deploy.create_templates
end

after 'deploy:finalize_update' do
  generate_database_yml

  #solved in Capfile
  #run "cd #{release_path}; RAILS_ENV=#{stage} rake assets:precompile"
end

namespace :deploy do

  # Passenger specifics: restart by touching the restart.txt file
  task :start, :roles => :app, :except => {:no_release => true} do
    restart
  end
  task :stop do
    ;
  end
  task :restart, :roles => :app, :except => {:no_release => true} do
    run "touch #{File.join(current_path, 'tmp', 'restart.txt')}"
  end

  # Remote bundle install
  task :rebundle do
    run "cd #{current_path} && bundle install"
    restart
  end

  task :bundle_update do
    run "cd #{current_path} && bundle update"
    restart
  end

  desc "Additional Symlinks to shared_path"
  task :additional_symlinks do
    run "rm -rf #{release_path}/tmp/shared_config"
    run "mkdir -p #{shared_path}/env_config"
    run "ln -nfs #{shared_path}/env_config #{release_path}/tmp/env_config"

    run "rm -f #{release_path}/db_dumps"
    run "ln -s #{shared_path}/db_dumps #{release_path}/db_dumps"
  end

  # Load the schema
  desc "Load the schema into the database (WARNING: destructive!)"
  task :schema_load, :roles => :db do
    run("cd #{current_path} && rake db:schema:load", :env => {'RAILS_ENV' => "#{stage}"})
  end

  # Run the sample data populator
  desc "Run the test data populator script to load test data into the db (WARNING: destructive!)"
  task :populate, :roles => :db do
    generate_populate_yml
    run("cd #{current_path} && rake db:populate", :env => {'RAILS_ENV' => "#{stage}"})
  end

  # Seed the db
  desc "Run the seeds script to load seed data into the db (WARNING: destructive!)"
  task :seed, :roles => :db do
    run("cd #{current_path} && rake db:seed", :env => {'RAILS_ENV' => "#{stage}"})
  end

  desc "Full redepoyment, it runs deploy:update and deploy:refresh_db"
  task :full_redeploy do
    update
    rebundle
    refresh_db
  end

  # Helper task which re-creates the database
  task :refresh_db, :roles => :db do
    require 'colorize'

    # Prompt to refresh_db on unless we're in QA
    if stage.eql?(:qa)
      input = "yes"
    else
      puts "This step (deploy:refresh_db) will erase all data and start from scratch.\nYou probably don't want to do it. Are you sure?' [NO/yes]".colorize(:red)
      input = STDIN.gets.chomp
    end

    if input.match(/^yes/)
      schema_load
      seed
      populate
    else
      puts "Skipping database nuke"
    end
  end

  desc "Safe redeployment"
  task :safe do # TODO roles?
    require 'colorize'
    update
    rebundle

    cat_migrations_output = capture("cd #{current_path} && rake db:cat_pending_migrations 2>&1", :env => {'RAILS_ENV' => stage}).chomp
    puts cat_migrations_output

    if cat_migrations_output != '0 pending migration(s)'
      print "There are pending migrations. Are you sure you want to continue? [NO/yes] ".colorize(:red)
      abort "Exiting because you didn't type 'yes'" unless STDIN.gets.chomp == 'yes'
    end

    backup.db.dump
    backup.db.trim
    migrate
    restart
  end

  desc 'Create extra config in central location'
  task :create_templates do
    require "yaml"
    require 'colorize'

    config = YAML::load_file('config/dc18a_config.yml')
    file_path = "#{config[stage.to_s]['extra_config_file_root']}/dc18a_extra_config.yml"
    output = capture("ls #{config[stage.to_s]['extra_config_file_root']}").strip

    if output[/dc18a_extra_config\.yml/].nil?
      run "#{try_sudo} chown -R #{user}.#{group} #{config[stage.to_s]['extra_config_file_root']}"
      run("cp #{release_path}/deploy_templates/dc18a_extra_config.yml #{config[stage.to_s]['extra_config_file_root']}", :env => {'RAILS_ENV' => "#{stage}"})
      print "\nNOTICE: Please update #{file_path} with the appropriate values and restart the server\n\n".colorize(:green)
    else
      print "\nALERT: Config file #{file_path} detected. Will not overwrite\n\n".colorize(:red)
    end

  end

  task :new_secret, :roles => :app do
    run("cd #{current_path} && rake app:generate_secret", :env => {'RAILS_ENV' => "#{stage}"})
  end

  namespace :shared_file do

    desc <<-DESC
      Generate shared file dirs under shared/files dir and then copies files over.

      For example, given:
        set :shared_files, %w(config/database.yml db/seeds.yml)

      The following directories will be generated:
        shared/files/config/
        shared/files/db/
    DESC

    task :setup, :except => { :no_release => true } do
      if exists?(:shared_files)
        dirs = shared_files.map {|f| File.join(shared_file_path, File.dirname(f)) }
        run "#{try_sudo} mkdir -p #{dirs.join(' ')}"
        run "#{try_sudo} chmod g+w #{dirs.join(' ')}" if fetch(:group_writable, true)
        run "#{try_sudo} chown -R #{user}.#{group} #{dirs.join(' ')}"

        servers = find_servers(:no_release => false)
        servers.each do |server|
          shared_files.each do |file_path|
            top.upload(file_path, File.join(shared_file_path, file_path))
            puts "    Uploaded #{file_path} to #{File.join(shared_file_path, file_path)}"
          end
        end

      end
    end
    after "deploy:setup", "deploy:shared_file:setup"

    desc <<-DESC
      Symlink shared files to release path.

      WARNING: It DOES NOT warn you when shared files not exist.  \
      So symlink will be created even when a shared file does not \
      exist.
    DESC
    task :create_symlink, :except => { :no_release => true } do
      (shared_files || []).each do |path|
        run "ln -nfs #{shared_file_path}/#{path} #{release_path}/#{path}"
      end
    end
    after "deploy:finalize_update", "deploy:shared_file:create_symlink"
  end

end

namespace :backup do
  namespace :db do
    desc "make a database backup"
    task :dump do
      run "cd #{current_path} && rake db:backup", :env => {'RAILS_ENV' => stage}
    end

    desc "trim database backups"
    task :trim do
      run "cd #{current_path} && rake db:trim_backups", :env => {'RAILS_ENV' => stage}
    end
  end
end

desc "Give sample users a custom password"
task :generate_populate_yml, :roles => :app do
  require "yaml"
  require 'colorize'

  puts "Set sample user password? (required on initial deploy) [NO/yes]".colorize(:red)
  input = STDIN.gets.chomp
  do_set_password if input.match(/^yes/)
end

desc "Helper method that actually sets the sample user password"
task :do_set_password, :roles => :app do
  set :custom_sample_password, proc { Capistrano::CLI.password_prompt("Sample User password: ") }
  buffer = Hash[:password => custom_sample_password]
  put YAML::dump(buffer), "#{shared_path}/env_config/sample_password.yml", :mode => 0664
end


desc "After updating code we need to populate a new database.yml"
task :generate_database_yml, :roles => :app do
  require "yaml"
  set :production_database_password, proc { Capistrano::CLI.password_prompt("Database password: ") }

  buffer = YAML::load_file('config/database.yml')
  # get rid of unneeded configurations
  buffer.delete('test')
  buffer.delete('development')
  buffer.delete('cucumber')
  buffer.delete('spec')

  # Populate production password
  buffer[rails_env]['password'] = production_database_password

  put YAML::dump(buffer), "#{release_path}/config/database.yml", :mode => 0664
end

after 'multistage:ensure' do
  set :rails_env, proc { "#{defined?(rails_env) ? rails_env : stage.to_s}" }
end

after 'multistage:ensure' do
  set(:rails_env) { "#{defined?(rails_env) ? rails_env : stage.to_s}" }
  set :shared_files, %W(config/ldap.yml)
end
