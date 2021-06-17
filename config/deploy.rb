# config valid only for current version of Capistrano
# capistranoのバージョンを記載。固定のバージョンを利用し続け、バージョン変更によるトラブルを防止する
lock '3.16.0'

# Capistranoのログの表示に利用する
set :application, 'myapp'
set :deploy_to, "/var/www/myapp"

# どのリポジトリからアプリをpullするかを指定する
set :repo_url,  'git@github.com:ShoheiTsuji-CRE/deploy_sample.git'

# rbenv
set :rbenv_type, :user
set :rbenv_ruby, '2.6.3'
set :rbenv_prefix, "RBENV_ROOT=#{fetch(:rbenv_path)} RBENV_VERSION=#{fetch(:rbenv_ruby)} #{fetch(:rbenv_path)}/bin/rbenv exec"
set :rbenv_map_bins, %w{rake gem bundle ruby rails}
set :rbenv_roles, :all # default value

append :linked_files, 'config/database.yml','config/master.key'

# # プロセス番号を記載したファイルの場所
# set :unicorn_pid, -> { "#{shared_path}/tmp/pids/unicorn.pid" }

# # Unicornの設定ファイルの場所
# set :unicorn_config_path, -> { "#{current_path}/config/unicorn.rb" }

namespace :deploy do
  desc 'Restart application'
  task :restart do
    invoke 'unicorn:restart'
  end

  desc 'Create database'
  task :db_create do
    on roles(:db) do |host|
      with rails_env: fetch(:rails_env) do
        within current_path do
          execute :bundle, :exec, :rake, 'db:create'
        end
      end
    end
  end

  desc 'Run seed'
  task :seed do
    on roles(:app) do
      with rails_env: fetch(:rails_env) do
        within current_path do
          execute :bundle, :exec, :rake, 'db:seed'
        end
      end
    end
  end

  after :publishing, :restart

  after :restart, :clear_cache do
    on roles(:web), in: :groups, limit: 3, wait: 10 do
    end
  end
end
