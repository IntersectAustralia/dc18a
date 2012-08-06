# Your HTTP server, Apache/etc
role :web, 'dc18a-qa'
# This may be the same as your Web server
role :app, 'dc18a-qa'
# This is where Rails migrations will run
role :db,  'dc18a-qa', :primary => true

