# Your HTTP server, Apache/etc
role :web, 'qa-server'
# This may be the same as your Web server
role :app, 'qa-server'
# This is where Rails migrations will run
role :db,  'qa-server', :primary => true

