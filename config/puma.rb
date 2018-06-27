#!/usr/bin/env puma
# environment 'production'
environment 'development'
threads 2, 16 # minimum 2 threads, maximum 32 threads
workers 8
port 3000
app_name = 'mmp'

application_path = "/home/tenmind/app/#{app_name}"

directory "#{application_path}/current"
# directory "#{application_path}/"

pidfile "#{application_path}/shared/pids/puma.pid"
state_path "#{application_path}/shared/sockets/puma.state"
stdout_redirect "#{application_path}/shared/log/puma.stdout.log", "#{application_path}/shared/log/puma.stderr.log"
# pidfile "#{application_path}/tmp/pids/puma.pid"
# state_path "#{application_path}/tmp/sockets/puma.state"
# stdout_redirect "#{application_path}/log/puma.stdout.log", "#{application_path}/log/puma.stderr.log"


# bind "unix://#{application_path}/shared/sockets/puma.sock"  #绑定sock
# activate_control_app "unix://#{application_path}/shared/sockets/pumactl.sock"

bind 'tcp://192.168.2.207:3000'    #绑定端口4301
worker_timeout 30

daemonize true

# on_worker_boot do
#    Thread.new{NoticeChannel.redis.subscribe}
# end

preload_app!

