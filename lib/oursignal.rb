# encoding: utf-8
root = File.join(File.dirname(__FILE__), '..')
$:.unshift File.join(root, 'lib')

Encoding.default_internal = 'UTF-8'
Encoding.default_external = 'UTF-8'

# Bundler.
require 'bundler'
Bundler.setup :default

# Persistence.
require 'swift'
Swift.setup :default, Swift::DB::Postgres, db: 'oursignal'
Swift.trace true

module Oursignal
  VERSION    = '0.3.0'
  USER_AGENT = "oursignal/#{VERSION} +oursignal.com"

  def self.root
    File.expand_path(File.join(File.dirname(__FILE__), '..'))
  end

  def self.db *args, &block
    Swift.db *args, &block
  end
end # Oursignal

