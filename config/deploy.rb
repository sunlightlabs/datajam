set :environment, (ENV['target'] || 'staging')

set :user, 'datajam'
set :application, user
set :deploy_to, "/projects/datajam/www"

if environment == 'production'
  set :domain, "sunlightlive.com"
else
  set :domain, "staging.sunlightlive.com"
end

set :repository,  "git@github.com:sunlightlabs/datajam.git"
set :scm, 'git'
set :use_sudo, false
set :deploy_via, :remote_cache

role :web, domain
role :app, domain
role :db,  domain, :primary => true

after "deploy", "deploy:cleanup"

namespace :deploy do
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "touch #{current_path}/tmp/restart.txt"
  end

  task :symlink_config do
    run "ln -s #{shared_path}/config/mongoid.yml #{release_path}/config/mongoid.yml"
  end
end

after 'deploy:update_code' do
  deploy.symlink_config
end
