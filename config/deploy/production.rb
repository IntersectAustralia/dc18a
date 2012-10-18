# Your HTTP server, Apache/etc
role :web, '172.16.4.92'
# This may be the same as your Web server
role :app, '172.16.4.92'
# This is where Rails migrations will run
role :db,  '172.16.4.92', :primary => true

