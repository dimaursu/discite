set :stage, :production

# Simple Role Syntax
# ==================
# Supports bulk-adding hosts to roles, the primary
# server in each group is considered to be the first
# unless any hosts have the primary property set.
role :all, %w{discite@alt.ceata.org}

set :branch, :master

set :default_env, { path: "#{shared_path}/bin:/home/discite/.rvm/bin:/home/discite/.nvm/bin:$PATH" }
set :deploy_to, "/home/discite/#{fetch(:stage)}"
set :keep_releases, 2

set :control_directory, "/home/discite"
set :format, :pretty
set :log_level, :debug

after 'deploy:updating', 'deploy:bundle'

puma_sock = "unix://#{fetch(:control_directory)}/#{fetch(:stage)}/sockets/puma.sock"
puma_control = "unix://#{fetch(:control_directory)}/#{fetch(:stage)}/sockets/pumactl.sock"
puma_state = "#{fetch(:control_directory)}/#{fetch(:stage)}/sockets/puma.state"
puma_log = "#{fetch(:control_directory)}/#{fetch(:stage)}/log/puma.log"

namespace :deploy do

  task :setup do
    on roles(:app) do
      within release_path do
        execute "mkdir -p #{fetch(:control_directory)}/#{fetch(:stage)}/{log,sockets}"
      end
    end
  end

  task :bundle do
    on roles(:app) do
      within release_path do
        execute :bundle, "install --quiet --without [:test, :development]"
      end
    end
  end

  task :start do
    on roles(:all) do
      within release_path do
        execute :puma,
          "-b #{puma_sock}",
          "-e production",
          "-t 2:4",
          "--control #{puma_control}",
          "-S #{puma_state} >> #{puma_log} 2>&1 &"
      end
    end
  end

  task :stop do
    on roles(:all) do
      within release_path do
        execute :pumactl, "-S #{puma_state} stop"
      end
    end
  end

  task :restart do
    on roles(:all) do
      within release_path do
        execute :pumactl, "-S #{puma_state} restart"
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

  task :status do
    on roles(:all) do
      within release_path do
        execute :pumactl, "-S #{puma_state} stats"
      end
    end
  end
end

