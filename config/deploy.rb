# config valid only for current version of Capistrano
lock '3.4.0'

set :application, 'goldenseal'
set :repo_url, 'https://github.com/curationexperts/goldenseal.git'
set :passenger_restart_with_touch, true
ask :branch, `git rev-parse --abbrev-ref HEAD`.chomp
set :deploy_to, '/opt/goldenseal'

# Default value for :scm is :git
# set :scm, :git

# Default value for :format is :pretty
# set :format, :pretty

# Default value for :log_level is :debug
# set :log_level, :debug

# Default value for :pty is false
# set :pty, true

# Default value for :linked_files is []
set :linked_files, fetch(:linked_files, []).push('config/blacklight.yml', 'config/database.yml', 'config/fedora.yml', 'config/redis.yml', 'config/resque-pool.yml', 'config/secrets.yml', 'config/solr.yml')

# Default value for linked_dirs is []
set :linked_dirs, fetch(:linked_dirs, []).push('log', 'tmp/pids', 'tmp/cache', 'tmp/sockets', 'vendor/bundle', 'public/system')

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for keep_releases is 5
# set :keep_releases, 5

namespace :deploy do

  after :restart, :clear_cache do
    on roles(:web), in: :groups, limit: 3, wait: 10 do
      # Here we can do anything such as:
      # within release_path do
      #   execute :rake, 'cache:clear'
      # end
    end
  end

end
