# encoding: utf-8
require 'config/dependencies.rb'

use_test :test_unit
use_template_engine :erb

Merb::Config.use do |c|
  c[:use_mutex] = false
  c[:session_store] = 'cookie'  # can also be 'memory', 'memcache', 'container', 'datamapper

  # cookie session store configuration
  c[:session_secret_key]  = '87107539db8cfa483be5b146200d88adb071300e'  # required for cookie session store
  c[:session_id_key] = '_oursignal/_session_id' # cookie session id key, defaults to "_session_id"
end

Merb::BootLoader.before_app_loads do
  MongoMapper.connection = XGen::Mongo::Driver::Mongo.new
  MongoMapper.database   = (Merb.environment == 'test' ? 'oursignal-test' : 'oursignal')
  Merb.logger.info("MongoMapper localhost/#{MongoMapper.database.name}")
end

Merb::BootLoader.after_app_loads do
  # This will get executed after your app's classes have been loaded.
end

Merb.add_mime_type :rss, nil, %w{text/xml}
