# #!/usr/bin/env puma

environment 'development'
# environment 'production'
#threads 2, 16 # minimum 2 threads, maximum 64 threads
#workers 8

app_name = 'mmp'

application_path = "/home/tenmind/#{app_name}"

# directory "#{application_path}/current"
# directory "#{application_path}/"

# pidfile "#{application_path}/pids/puma.pid"
# state_path "#{application_path}/sockets/puma.state"
# stdout_redirect "#{application_path}/shared/log/puma.stdout.log", "#{application_path}/shared/log/puma.stderr.log"
# pidfile "#{application_path}/tmp/pids/puma.pid"
# state_path "#{application_path}/tmp/sockets/puma.state"
# stdout_redirect "#{application_path}/log/puma.stdout.log", "#{application_path}/log/puma.stderr.log"


# bind "unix://#{application_path}/shared/tmp/sockets/puma.sock"  #绑定sock
# bind 'tcp://192.168.2.207:3000'    #绑定端口4301
worker_timeout 30

daemonize false

# 胡俊专用
# threads_count = ENV.fetch("RAILS_MAX_THREADS") { 2 }
# threads 2, 16
# workers 8
# port 3000
# environment 'development'
# application_path = "/home/hujun/work/mmp"
# #这里一定要配置为项目路径下地current
# pidfile "#{application_path}/tmp/puma.pid"
# state_path "#{application_path}/tmp/puma.state"
# stdout_redirect "#{application_path}/log/puma.stdout.log", "#{application_path}/log/puma.stderr.log"
# bind "unix://#{application_path}/tmp/health.sock"
# activate_control_app "unix://#{application_path}/tmp/pumactl.sock"

# preload_app!

# #后台运行
# daemonize true

# on_worker_boot do
#   # p '666666666666666666666666666666666'
#   # p Thread.new{NoticeChannel.redis.subscribe}
# end