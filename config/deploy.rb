require 'capistrano/ext/common'
require 'capistrano/ext/debian'
require 'capistrano/ext/git'
require 'capistrano/ext/apache'
require 'capistrano/ext/passenger'
require 'capistrano/ext/merb'
require 'capistrano/ext/curb'
require 'capistrano/ext/nokogiri'
require 'capistrano/ext/mysql'
require 'capistrano/ext/multistage'

set :application, 'oursignal'
set :repository,  'git@github.com:stateless-systems/oursignal.git'

set :gems, fetch(:gems, []).push('jeweler')

set(:default_environment) do
  { 'MERB_ENV' => stage }
end

namespace :deploy do
  desc 'Recreate crontab'
  task :crontab do
    run "#{thor} os:crontab:redeploy"
  end
end

after 'deploy:restart'.to_sym, 'deploy:crontab'
