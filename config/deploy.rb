# config valid only for current version of Capistrano
lock '3.9.0'

user = 'ubuntu'
domain = 'depot.rails.prod'

set :application, 'depot'

set :repo_url, "ssh://#{user}@#{domain}:2200/home/#{user}/git/#{fetch(:applicaton)}git"
set :deploy_to, "/home/#{user}/deploy/#{fetch(:applicaton)}"

# domains for various servers (in this case all are on the same machine)
role :app, domain
role :web, domain
role :db, domain

# Default branch is :master
# ask :branch, `git rev-parse --abbrev-ref HEAD`.chomp

# Default deploy_to directory is /var/www/my_app_name
# set :deploy_to, '/var/www/my_app_name'

# Default value for :format is :airbrussh.
# set :format, :airbrussh

# You can configure the Airbrussh format using :format_options.
# These are the defaults.
# set :format_options, command_output: true, log_file: 'log/capistrano.log', color: :auto, truncate: :auto

# Default value for :pty is false
# set :pty, true

# Default value for :linked_files is []
# append :linked_files, 'config/database.yml', 'config/secrets.yml'

# Default value for linked_dirs is []
# append :linked_dirs, 'log', 'tmp/pids', 'tmp/cache', 'tmp/sockets', 'public/system'

# Default value for default_env is {}
# set :default_env, { path: '/opt/ruby/bin:$PATH' }

# Default value for local_user is ENV['USER']
# set :local_user, -> { `git config user.name`.chomp }

# Default value for keep_releases is 5
# set :keep_releases, 5
