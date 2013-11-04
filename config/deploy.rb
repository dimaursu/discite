set :application, 'discite'
set :repo_url, 'git://gitorious.org/discite/discite.git'
set :branch, :master


set :deploy_to, '/home/discite/discite/'

set :keep_releases, 2

after 'deploy:updating', 'deploy:bundle_install'

#puma_sock = "unix://#{shared_path}/sockets/puma.sock"
puma_sock = "tcp://0.0.0.0:4000"
puma_control = "unix://#{shared_path}/sockets/pumactl.sock"
puma_state = "#{shared_path}/sockets/puma.state"
puma_log = "#{shared_path}/log/puma.log"

namespace :deploy do

  task :bundle_install do
    on roles(:app) do
      within release_path do
        execute :bundle, "install --quiet --without [:test, :development]"
      end
    end
  end

  desc "Start the application"
  task :start do
    on roles(:all) do
      within release_path do
        background :puma,
          "-b #{puma_sock}",
          "-e #{fetch(:stage)}",
          "-t 2:4",
          "--control #{puma_control}",
          "-S #{puma_state} >> #{puma_log} 2>&1"
      end
    end
  end

  desc "Stop the application"
  task :stop do
    on roles(:all) do
      within release_path do
        background :pumactl, "-S #{puma_state} stop"
      end
    end
  end

  desc "Restart the application"
  task :restart do
    on roles(:all) do
      within release_path do
        background :pumactl, "-S #{puma_state} restart"
      end
    end
  end

  task :compile_assets do
    on roles(:all) do
      within release_path do
        execute :rake, "assets:precompile"
      end
    end
  end

  desc "Status of the application"
  task :status do
    on roles(:all) do
      within release_path do
        execute "RAILS_ENV=#{fetch(:stage)} pumactl -S #{puma_state} stats"
      end
    end
  end

end

