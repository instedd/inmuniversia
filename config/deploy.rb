# Copyright (C) 2013, InSTEDD
#
# This file is part of Inmuniversia.
#
# Inmuniversia is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# Inmuniversia is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with Inmuniversia.  If not, see <http://www.gnu.org/licenses/>.

set :stages, %w(staging)
set :default_stage, "staging"

require 'capistrano/ext/multistage'
require 'bundler/capistrano'
require 'rvm/capistrano'

set :rvm_ruby_string, '1.9.3'
set :rvm_type, :system
set :application, "inmuniversia"
set :repository,  "https://bitbucket.org/instedd/inmuniversia"
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
    run "ln -nfs #{shared_path}/database.yml #{release_path}/config/"
    run "ln -nfs #{shared_path}/newrelic.yml #{release_path}/config/"
  end
end

before "deploy:finalize_update", "deploy:symlinks"
after "deploy:update_code", "deploy:migrate"