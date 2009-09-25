# encoding: utf-8
# Stupid fucking people requiring the entire active_support when they don't even need the json bullshit in there.
# The monkey patching conflicts with the monkey patching in json.
Merb.disable :json

require 'config/dependencies.rb'

use_test :test_unit
use_orm :datamapper
use_template_engine :erb

Merb::Config.use do |c|
  c[:use_mutex] = false
  c[:session_store] = 'cookie'  # can also be 'memory', 'memcache', 'container', 'datamapper

  # cookie session store configuration
  c[:session_secret_key]  = '87107539db8cfa483be5b146200d88adb071300e'  # required for cookie session store
  c[:session_id_key] = '_oursignal/_session_id' # cookie session id key, defaults to "_session_id"
end

Merb::BootLoader.before_app_loads do
  require 'uri/meta'
  require 'moneta/memcache'
  URI::Meta::Cache.cache = Moneta::Memcache.new(
    :server    => 'localhost:11211',
    :namespace => 'uri_meta'
  )

  require 'math/uniform_distribution'
  Math::UniformDistribution.cache = Moneta::Memcache.new(
    :server    => 'localhost:11211',
    :namespace => 'math_uniform_distribution'
  )

  # Prevent IOError when running under passenger I hope.
  ::OpenID::Util.logger = Merb.logger

  require 'dm/types'
  require 'ext/string'
  require 'ext/float'
  require 'ext/struct'

  Merb::Plugins.config[:exceptions] = {
    :email_addresses        => ['shane@statelesssystems.com'],
    :app_name               => 'oursignal.com',
    :environments           => ['production', 'staging', 'rake'],
    :email_from             => 'exceptions@oursignal.com',
    :mailer_config          => nil,
    :mailer_delivery_method => :sendmail
  }

  Merb::Cache.setup do
    register(:page, Merb::Cache::PageStore[Merb::Cache::FileStore], :dir => Merb.root / 'public') unless exists?(:page)
    register(:default, Merb::Cache::AdhocStore[:page]) unless exists?(:default)
  end
end

Merb::BootLoader.after_app_loads do
end

Merb.add_mime_type :rss, nil, %w{text/xml}
