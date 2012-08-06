# Your HTTP server, Apache/etc
role :web, 'staging-server'
# This may be the same as your Web server
role :app, 'staging-server'
# This is where Rails migrations will run
role :db,  'staging-server', :primary => true

