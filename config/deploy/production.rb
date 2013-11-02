set :stage, :production

# Simple Role Syntax
# ==================
# Supports bulk-adding hosts to roles, the primary
# server in each group is considered to be the first
# unless any hosts have the primary property set.
role :all, %w{discite@alt.ceata.org}

puma_sock = "unix://#{shared_path}/sockets/puma.sock"
puma_control = "unix://#{shared_path}/sockets/pumactl.sock"
puma_state = "#{shared_path}/sockets/puma.state"
puma_log = "#{shared_path}/log/puma-#{fetch(:stage)}.log"

after 'deploy:updating', 'deploy:bundle_install'

namespace :deploy do
  desc "Start the application"
  task :start do
    on roles(:all) do
      execute "cd #{current_path} && RAILS_ENV=#{fetch(:stage)} puma -b '#{puma_sock}' -e #{fetch(:stage)} -t2:4 --control '#{puma_control}' -S #{puma_state} >> #{puma_log} 2>&1 &", :pty => false
    end
  end

  desc "Stop the application"
  task :stop do
    on roles(:all) do
      within release_path do
        execute "RAILS_ENV=#{fetch(:stage)} pumactl -S #{puma_state} stop"
      end
    end
  end

  desc "Restart the application"
  task :restart do
    on roles(:all) do
      within release_path do
        execute "RAILS_ENV=#{fetch(:stage)} pumactl -S #{puma_state} restart"
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

  task :bundle_install do
    on roles(:app) do
      within release_path do
        execute :bundle, "install --quiet --system --without [:test, :development]"
      end
    end
  end
end

