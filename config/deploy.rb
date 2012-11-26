require 'bundler/capistrano'

set :application, 'postclip'
set :repository,  'git@49.212.160.224:postclip.git'
set :deploy_to, "/home/yoshida/public_html/#{application}"
set :rails_env, 'production'
set :user, 'yoshida'
set :use_sudo, false 

set :scm, :git
# Or: `accurev`, `bzr`, `cvs`, `darcs`, `git`, `mercurial`, `perforce`, `subversion` or `none`

role :web, '49.212.160.224'                          # Your HTTP server, Apache/etc
role :app, '49.212.160.224'                          # This may be the same as your `Web` server
role :db,  '49.212.160.224', :primary => true # This is where Rails migrations will run

# if you want to clean up old releases on each deploy uncomment this:
# after "deploy:restart", "deploy:cleanup"

# if you're still using the script/reaper helper you will need
# these http://github.com/rails/irs_process_scripts

# If you are using Passenger mod_rails uncomment this:
# namespace :deploy do
#   task :start do ; end
#   task :stop do ; end
#   task :restart, :roles => :app, :except => { :no_release => true } do
#     run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
#   end
# end

namespace :deploy do
  task :start, :roles => :app do
    run "cd #{current_path}; bundle exec unicorn_rails -c config/unicorn.rb -E #{rails_env} -D --path /#{application}"
  end

  task :restart, :roles => :app do
    run "kill -s USR2 `cat #{current_path}/tmp/pids/unicorn.pid`"
  end

  task :stop, :roles => :app do
    run "kill -s QUIT `cat #{current_path}/tmp/pids/unicorn.pid`"
  end
end
