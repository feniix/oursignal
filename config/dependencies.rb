merb_gems_version = '1.1'

# bin/merb -V to get a better error messages.
dependency 'merb-core', merb_gems_version
dependency 'merb-assets', merb_gems_version
dependency('merb-cache', merb_gems_version) do
  Merb::Cache.setup do
    register(Merb::Cache::FileStore) unless Merb.cache
  end
end
dependency 'merb-actionorm', merb_gems_version # only required for helpers :(
dependency 'merb-helpers', merb_gems_version
dependency 'merb-exceptions', merb_gems_version
dependency 'merb-slices', merb_gems_version
dependency 'merb-auth-core', merb_gems_version
dependency 'merb-auth-more', merb_gems_version
dependency 'merb-param-protection', merb_gems_version
dependency 'merb-exceptions', merb_gems_version

dependency 'addressable', '2.1.0', :require_as => 'addressable/uri'
dependency 'hpricot', '0.8.1'
dependency 'nokogiri', '1.2.3'
dependency 'ruby-openid', '2.1.6', :require_as => 'openid'

# github
dependency 'jnunemaker-mongomapper', '0.1.1', :require_as => 'mongomapper'
dependency 'thoughtbot-shoulda', '2.10.1', :require_as => nil
dependency 'jnunemaker-columbus', '0.1.2', :require_as => 'columbus'
dependency 'pauldix-feedzirra', '0.0.12', :require_as => 'feedzirra'
