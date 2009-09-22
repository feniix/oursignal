require 'capistrano/ext/common'
require 'capistrano/ext/centos'
require 'capistrano/ext/git'
require 'capistrano/ext/apache'
require 'capistrano/ext/passenger'
require 'capistrano/ext/merb'
require 'capistrano/ext/curb'
require 'capistrano/ext/nokogiri'
require 'capistrano/ext/mysql'
require 'capistrano/ext/memcached'
require 'capistrano/ext/monit'
require 'capistrano/ext/varnish'
require 'capistrano/ext/multistage'

role :web, '72.47.219.75'
role :app, '72.47.219.75'
role :db, '72.47.219.75', :primary => true

set :application, 'oursignal'
set :repository,  'git@github.com:stateless-systems/oursignal.git'

# Jeweler is required on the system level because Rakefile loads it before the
# gem paths are tweaked by Merb
set :gems, fetch(:gems, []).push('jeweler')

# Change the apache port because we run a caching service (varnish) on port 80
set :apache_port, '8080'

set(:default_environment) do
  { 'MERB_ENV' => stage }
end

namespace :deploy do
  desc 'Recreate crontab'
  task :crontab do
    run "#{thor} os:crontab:redeploy"
  end

  desc 'Custom migrations'
  task :migrate do
    run "#{rake} db:migrate && #{thor} os:db:migrate"
  end
end

after 'deploy:restart'.to_sym, 'deploy:crontab'
