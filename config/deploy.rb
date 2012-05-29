require 'capistrano_colors'

set :bundle_cmd, '. /etc/profile && bundle'
require "bundler/capistrano"

set :whenever_roles, :app
set :whenever_command, '. /etc/profile && bundle exec whenever'
require "whenever/capistrano"

require 'yaml'

CONFIG = YAML.load_file('config/config.yml')

set :application, "New DVDs"
set :repository, CONFIG['deploy']['repo']

set :scm, :git
set :deploy_to, "#{CONFIG['deploy']['base']}/#{CONFIG['app']['name']}"
set :deploy_via, :copy
set :keep_releases, 3
set :use_sudo, false
set :normalize_asset_timestamps, false

set :user, CONFIG['deploy']['ssh_user']
ssh_options[:port] = CONFIG['deploy']['ssh_port']
ssh_options[:keys] = eval(CONFIG['deploy']['ssh_key'])

role :app, CONFIG['deploy']['ssh_host']

after "deploy:update", "deploy:cleanup"
after "deploy:setup", "deploy:more_setup"

before "deploy:create_symlink", "deploy:configs"

namespace :deploy do

  desc 'More setup.. ensure necessary directories exist, etc'
  task :more_setup do
    run "mkdir -p #{shared_path}/config #{shared_path}/log"
  end

  desc 'Deploy necessary configs into shared/config'
  task :configs do
    put CONFIG.reject { |x| [ 'deploy' ].include?(x) }.to_yaml, "#{shared_path}/config/config.yml"
    run "ln -nfs #{shared_path}/config/config.yml #{release_path}/config/config.yml"
  end
end