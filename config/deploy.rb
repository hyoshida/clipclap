require 'bundler/capistrano'

set :application, 'clipclap'
set :repository,  'https://github.com/hyoshida/clipclap.git'
set :deploy_to, "/home/yoshida/public_html/#{application}"
set :rails_env, 'production'
set :user, 'yoshida'
set :use_sudo, false 

set :scm, :git
# Or: `accurev`, `bzr`, `cvs`, `darcs`, `git`, `mercurial`, `perforce`, `subversion` or `none`

role :web, 'clipclap.org'                   # Your HTTP server, Apache/etc
role :app, 'clipclap.org'                   # This may be the same as your `Web` server
role :db,  'clipclap.org', :primary => true # This is where Rails migrations will run

require 'capistrano-rbenv'
set :rbenv_ruby_version, '2.0.0-p353'

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

default_run_options[:pty] = true

set :foreman_export_format, 'bluepill'
set :foreman_location_path, "#{shared_path}/bluepill"

namespace :foreman do
  desc "Export the Procfile to scripts"
  task :export, roles: :app do
    run "if [ ! -d #{foreman_location_path} ]; then mkdir -p #{foreman_location_path}; fi"
    run "cd #{current_path} && bundle exec foreman export #{foreman_export_format} #{foreman_location_path} #{foreman_format(foreman_options)}"
  end

  def foreman_options
    {
      app: application,
      log: "#{shared_path}/log",
      user: user
    }
  end

  def foreman_format(opts)
    opts.map {|opt,value| "--#{opt}='#{value}'" }.join(' ')
  end
end

after 'deploy:update', 'foreman:export'

namespace :bluepill do
  desc "Stop processes that bluepill is monitoring and quit bluepill"
  task :quit, roles: :app do
    run "cd #{current_path} && #{sudo} bundle exec bluepill stop"
    run "cd #{current_path} && #{sudo} bundle exec bluepill quit"
  end

  desc "Load bluepill configuration and start it"
  task :start, roles: :app do
    run "cd #{current_path} && #{sudo} bundle exec bluepill load #{foreman_location_path}/#{application}.pill"
  end

  desc "Restart bluepill by quit and start task"
  task :restart, roles: :app do
    bluepill.quit rescue puts '[WARNING] Bluepill was not running?'
    bluepill.start
  end

  desc "Prints bluepills monitored processes statuses"
  task :status, roles: :app do
    run "cd #{current_path} && #{sudo} bundle exec bluepill status"
  end
end

after "deploy:update", "bluepill:restart"

namespace :deploy do
  desc "Create a symbolic link .env file to release path"
  task :link_dotenv, roles: :app do
    run "ln -fns #{shared_path}/config/.env #{release_path}/.env"
  end
end

before 'foreman:export', 'deploy:link_dotenv'
