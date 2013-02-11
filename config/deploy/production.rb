# Your HTTP server, Apache/etc
role :web, '138.25.37.201'
# This may be the same as your Web server
role :app, '138.25.37.201'
# This is where Rails migrations will run
role :db,  '138.25.37.201', :primary => true
# The user configured to run the rails app
set :user, 'dc18a'

