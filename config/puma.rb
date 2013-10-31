rails_env = ENV['RAILS_ENV'] || 'development'

threads 4,4
port = 4000
deploy_dir = "/home/discite/discite/deployments/current"

bind  "tcp://0.0.0.0:#{port}"
pidfile "#{deploy_dir}/tmp/pids/puma.pid"
state_path "#{deploy_dir}/tmp/puma/state"

activate_control_app
