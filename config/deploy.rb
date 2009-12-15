# the name of your subversion application
set :application, "moviefly.org" 
set :repository,  "http://svn.moviefly.org/trunk"

set :user, "moviefly"
set :deploy_to, "/home/#{user}/#{application}"

# Dreamhost doesn't allow you to use sudo.
set :use_sudo, false

role :app, application
role :web, application
role :db, application

#after "deploy:update_code", "deploy:rails_symlink"
namespace :deploy do

  desc "Restarting mod_rails with restart.txt"
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "touch #{current_path}/tmp/restart.txt"
  end

  # desc "Create a symlink to a local rails dir instead of using the gem"
  # task :rails_symlink do
  #   run "ln -nfs #{deploy_to}/#{shared_dir}/rails #{release_path}/vendor/rails"
  # end
end