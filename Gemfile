# vim: syntax=ruby
bundle_path 'gems'
disable_rubygems
disable_system_gems

# Web.
gem 'rack'
gem 'haml'
gem 'rdiscount'

# Branch has improved 1.9 named capture routing.
gem 'sinatra', '1.1.1' # http://github.com/shanna/sinatra/tree/named_capture_routing

# gem 'sinatra-auth'
# gem 'rack-flash'

# Business.
gem 'swift'

# Jobs.
gem 'yajl-ruby'
gem 'resque'
gem 'resque-lock'

only :development do
  gem 'unicorn'
end

only :test do
  gem 'ansi'
end
