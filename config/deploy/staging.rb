# Your HTTP server, Apache/etc
role :web, 'dc18a-staging'
# This may be the same as your Web server
role :app, 'dc18a-staging'
# This is where Rails migrations will run
role :db,  'dc18a-staging', :primary => true

