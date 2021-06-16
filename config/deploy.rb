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
# set :rbenv_path, '/usr/local/rbenv'
set :rbenv_ruby, '2.6.3'
set :rbenv_prefix, "RBENV_ROOT=#{fetch(:rbenv_path)} RBENV_VERSION=#{fetch(:rbenv_ruby)} #{fetch(:rbenv_path)}/bin/rbenv exec"
set :rbenv_map_bins, %w{rake gem bundle ruby rails}
set :rbenv_roles, :all # default value

append :linked_files, 'config/master.key'
