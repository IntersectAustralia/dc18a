require File.dirname(__FILE__) + '/sample_data_populator.rb'
begin  
  namespace :db do  
    desc "Populate the database with some sample data for testing"
    task :populate => :environment do
      if Rails.env.production?
        populate_data_for_production
      else
        populate_data_for_development
      end
    end
  end  
rescue LoadError  
  puts "It looks like some Gems are missing: please run bundle install"  
end