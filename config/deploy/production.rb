#############################################################
#	Application
#############################################################

set :user, 'moviefly'
set :application, "moviefly"
set :deploy_to, "/home/moviefly/moviefly.org/"

#############################################################
#	Settings
#############################################################

default_run_options[:pty] = true
ssh_options[:forward_agent] = true
set :use_sudo, true
set :scm_verbose, true
set :rails_env, "production" 

#############################################################
#	Servers
#############################################################

set :user, "moviefly"
set :domain, "www.moviefly.org"
server domain, :app, :web
role :db, domain, :primary => true

#############################################################
#	Git
#############################################################

# set :scm, :svn
set :branch, "trunk"
set :scm_user, 'MovieFly'
set :scm_passphrase, "mnbvcxz"
set :repository, "http://svn.moviefly.org/"
set :deploy_via, :remote_cache

#############################################################
#	Passenger
#############################################################

namespace :deploy do
  desc "Create the database yaml file"
  task :after_update_code do
    #########################################################
    # Uncomment the following to symlink an uploads directory.
    # Just change the paths to whatever you need.
    #########################################################
    
    # desc "Symlink the upload directories"
    # task :before_symlink do
    #   run "mkdir -p #{shared_path}/uploads"
    #   run "ln -s #{shared_path}/uploads #{release_path}/public/uploads"
    # end
  
  end
    
  # Restart passenger on deploy
  desc "Restarting mod_rails with restart.txt"
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "touch #{current_path}/tmp/restart.txt"
  end
  
  [:start, :stop].each do |t|
    desc "#{t} task is a no-op with mod_rails"
    task t, :roles => :app do ; end
  end
end
