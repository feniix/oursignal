# vim: syntax=ruby
%w{
  common
  db
}.each do |r|
  require File.join(File.dirname(__FILE__), r)
end
