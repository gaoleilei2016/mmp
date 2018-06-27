# 公司131服务器部署脚本
$:.unshift(File.expand_path('./lib', ENV['rvm_path'])) #for 131
# require 'bundler/capistrano'
set :application, 'mmp'
# set :repository,  "git@39.108.131.226:/home/git/mmp.git"
set :repository, "git@192.168.2.133:/home/git/mmp.git"
set :deploy_to, "/home/tenmind/app/mmp"
set :normalize_asset_timestamps, false
set :scm, :git
set :user, 'tenmind'
# set :user, 'liuyi'
# set :password, nil
# set(:env, 'development') unless exists?(:env)
set(:env, 'production') unless exists?(:env)
set(:branch, 'release_tenmind') unless exists?(:branch)
# set(:branch, 'yy_test') unless exists?(:branch)
# set :deploy_env, 'development'
# set :deploy_env, 'production'

# role :web, "39.108.131.226"                          # Your HTTP server, Apache/etc
# role :app, "39.108.131.226"                         # This may be the same as your `Web` server
# role :db,  "39.108.131.226", :primary => true # This is where Rails migrations will run

# role :web, "120.79.172.8"                          # Your HTTP server, Apache/etc
# role :app, "120.79.172.8"                         # This may be the same as your `Web` server
# role :db,  "120.79.172.8", :primary => true # This is where Rails migrations will run2
role :web, "192.168.2.207"                          # Your HTTP server, Apache/etc
role :app, "192.168.2.207"                         # This may be the same as your `Web` server
role :db,  "192.168.2.207", :primary => true # This is where Rails migrations will run
set :use_sudo, false
set :rvm_type, :system  #for 130
# set :rvm_type, :tenmind  #for 131
# set :rvm_ruby_version , '1.9.3'
# set :rvm_ruby_string, '1.9.3-p547@r1r3'
set :default_shell, '/bin/bash -l' #131
# 此命令使 Capistrano 在服务器上只克隆/导出仓库一次，然后在每次部署时使用 svn up 或 git pull 代替
set :deploy_via, :remote_cache


namespace :deploy do
 
  desc 'Restart puma'
  task :restart do
    # run "cp /home/tenmind/app/mmp/conf/rabbitmq.yml /home/tenmind/app/mmp/current/config/rabbitmq.yml
    #      && cp /home/tenmind/app/mmp/conf/mongoid.yml /home/tenmind/app/mmp/current/config/mongoid.yml
    #      && cp /home/tenmind/app/mmp/conf/ip.yml /home/tenmind/app/mmp/current/config/setup/ip.yml
    run "cp /home/tenmind/app/mmp/conf/puma.rb /home/tenmind/app/mmp/current/config/puma.rb 
         && cd /home/tenmind/app/mmp/current && rvm use 2.3.3 && bundle install --local && bundle exec pumactl --state /home/tenmind/app/mmp/shared/sockets/puma.state restart"
         # && cd /app/mmp_puma/current && bundle exec rake assets:precompile
  end

  desc 'Start puma'
  task :start do
    # run "cp /home/tenmind/app/mmp/conf/rabbitmq.yml /home/tenmind/app/mmp/current/config/rabbitmq.yml
    #      && cp /home/tenmind/app/mmp/conf/mongoid.yml /home/tenmind/app/mmp/current/config/mongoid.yml
    #      && cp /home/tenmind/app/mmp/conf/ip.yml /home/tenmind/app/mmp/current/config/setup/ip.yml
    run "cp /home/tenmind/app/mmp/conf/puma.rb /home/tenmind/app/mmp/current/config/puma.rb 
         && cd /home/tenmind/app/mmp/current && rvm use 2.3.3 && bundle install --local && bundle exec puma -C /home/tenmind/app/mmp/current/config/puma.rb"
  end

  desc 'Stop puma'
  task :stop do
    run "cd /home/tenmind/app/mmp/current && rvm use 2.3.3 && bundle install --local && bundle exec pumactl --state /home/tenmind/app/mmp/shared/sockets/puma.state stop"
  end
end
