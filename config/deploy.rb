set :stages, %w(staging)
set :default_stage, "staging"

require 'capistrano/ext/multistage'
require 'bundler/capistrano'
require 'rvm/capistrano'

set :rvm_ruby_string, '1.9.3'
set :rvm_type, :system
set :application, "inmuniversia"
set :repository,  "ssh://hg@bitbucket.org/instedd/inmuniversia"
set :scm, :mercurial

ssh_options[:forward_agent] = true
default_environment['TERM'] = ENV['TERM']

load 'lib/deploy/seed'

namespace :deploy do
  task :start do ; end
  task :stop do ; end
  
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
  end

  task :symlinks, :roles => :app do
    run "ln -nfs #{shared_path}/settings.yml #{release_path}/config/settings.local.yml"
    run "rm #{release_path}/config/database.yml"
    run "ln -nfs #{shared_path}/database.yml #{release_path}/config/"
  end
end

after "deploy:update_code", "deploy:migrate"