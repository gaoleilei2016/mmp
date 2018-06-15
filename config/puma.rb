# #!/usr/bin/env puma

<<<<<<< HEAD
environment 'development'
# environment 'production'
#threads 2, 16 # minimum 2 threads, maximum 64 threads
#workers 8
=======
# # environment 'production'
# environment 'production'
# threads 2, 16 # minimum 2 threads, maximum 64 threads
# workers 8
>>>>>>> qinxiao

# app_name = 'mmp'

<<<<<<< HEAD
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
=======
# application_path = "/home/tenmind/app/#{app_name}"

# directory "#{application_path}/current"
# # directory "#{application_path}/"

# pidfile "#{application_path}/shared/pids/puma.pid"
# state_path "#{application_path}/shared/sockets/puma.state"
# stdout_redirect "#{application_path}/shared/log/puma.stdout.log", "#{application_path}/shared/log/puma.stderr.log"
# # pidfile "#{application_path}/tmp/pids/puma.pid"
# # state_path "#{application_path}/tmp/sockets/puma.state"
# # stdout_redirect "#{application_path}/log/puma.stdout.log", "#{application_path}/log/puma.stderr.log"


# # bind "unix://#{application_path}/shared/tmp/sockets/puma.sock"  #绑定sock
# bind 'tcp://192.168.2.207:3000'    #绑定端口4301
# worker_timeout 30

# daemonize true

# preload_app!



# 以上是部署文件

# Puma can serve each request in a thread from an internal thread pool.
# The `threads` method setting takes two numbers: a minimum and maximum.
# Any libraries that use thread pools should be configured to match
# the maximum value specified for Puma. Default is set to 5 threads for minimum
# and maximum; this matches the default thread size of Active Record.
#
threads_count = ENV.fetch("RAILS_MAX_THREADS") { 5 }
threads threads_count, threads_count

# Specifies the `port` that Puma will listen on to receive requests; default is 3000.
#
port        ENV.fetch("PORT") { 3000 }

# Specifies the `environment` that Puma will run in.
#
environment ENV.fetch("RAILS_ENV") { "development" }

# Specifies the number of `workers` to boot in clustered mode.
# Workers are forked webserver processes. If using threads and workers together
# the concurrency of the application would be max `threads` * `workers`.
# Workers do not work on JRuby or Windows (both of which do not support
# processes).
#
# workers ENV.fetch("WEB_CONCURRENCY") { 2 }

# Use the `preload_app!` method when specifying a `workers` number.
# This directive tells Puma to first boot the application and load code
# before forking the application. This takes advantage of Copy On Write
# process behavior so workers use less memory. If you use this option
# you need to make sure to reconnect any threads in the `on_worker_boot`
# block.
#
# preload_app!

# If you are preloading your application and using Active Record, it's
# recommended that you close any connections to the database before workers
# are forked to prevent connection leakage.
#
# before_fork do
#   ActiveRecord::Base.connection_pool.disconnect! if defined?(ActiveRecord)
# end

# The code in the `on_worker_boot` will be called if you are using
# clustered mode by specifying a number of `workers`. After each worker
# process is booted, this block will be run. If you are using the `preload_app!`
# option, you will want to use this block to reconnect to any threads
# or connections that may have been created at application boot, as Ruby
# cannot share connections between processes.
#
# on_worker_boot do
#   ActiveRecord::Base.establish_connection if defined?(ActiveRecord)
# end
#

# Allow puma to be restarted by `rails restart` command.
plugin :tmp_restart
>>>>>>> qinxiao

