set :application, 'Discite'
set :repo_url, 'git://gitorious.org/discite/discite.git'

set :branch, :master
set :stage, :production

set :deploy_to, '/home/discite/discite/'
set :scm, :git
set :user, "discite"
set :ssh_options, { :forward_agent => true }
set :use_sudo, false

set :format, :pretty
set :log_level, :debug
set :pty, true

set :linked_files, %w{config/database.yml}
set :linked_dirs, %w{bin log tmp/pids tmp/cache tmp/sockets vendor/bundle public/system}

set :keep_releases, 2

set :app_server, :puma
