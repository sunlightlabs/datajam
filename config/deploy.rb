$:.unshift(File.expand_path('./lib', ENV['rvm_path']))
require "rvm/capistrano"
require "bundler/capistrano"
set :rvm_ruby_string, '1.9.2'
set :rvm_type, :user

set :environment, (ENV['target'] || 'staging')
set :user, 'datajam'
set :application, user
set :deploy_to, "/projects/datajam/www"
set :repository,  "git@github.com:sunlightlabs/datajam.git"
set :scm, 'git'
set :use_sudo, false
set :deploy_via, :remote_cache
set :unicorn_pid, "#{current_path}/tmp/pids/unicorn.pid"

if environment == 'production'
  set :domain, "sunlightlive.com"
else
  set :domain, "staging.sunlightlive.com"
end

role :web, domain
role :app, domain
role :db,  domain, :primary => true

namespace :deploy do
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "touch #{current_path}/tmp/restart.txt"
  end

  task :symlink_config do
    run "ln -s #{shared_path}/config/mongoid.yml #{release_path}/config/mongoid.yml"
  end
end

namespace :unicorn do
  desc "start unicorn"
  task :start, :roles => :app, :except => { :no_release => true } do
    run "cd #{current_path} && unicorn_rails -c #{current_path}/config/unicorn.rb -E production -D"
  end
  desc "stop unicorn"
  task :stop, :roles => :app, :except => { :no_release => true } do
    run "kill `cat #{unicorn_pid}`"
  end
  desc "graceful stop unicorn"
  task :graceful_stop, :roles => :app, :except => { :no_release => true } do
    run "kill -s QUIT `cat #{unicorn_pid}`"
  end
  desc "reload unicorn"
  task :reload, :roles => :app, :except => { :no_release => true } do
    run "kill -s USR2 `cat #{unicorn_pid}`"
  end

  task :restart, :roles => :app, :except => { :no_release => true } do
    stop
    start
  end
end

after "deploy", "deploy:cleanup"
#after "deploy:update_code", "deploy:symlink_config"
after "deploy:restart", "unicorn:restart"
