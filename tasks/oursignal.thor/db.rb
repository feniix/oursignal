require File.join(File.dirname(__FILE__), 'common')

module Oursignal
  class Db < Thor
    def self.new(*args)
      Oursignal.merb_env
      super(*args)
    end

    desc 'migrate', '(Re)create default oursignal defaults'
    def migrate
      Theme.first_or_create(:name => 'treemap')
      User.first_or_create({:username => 'oursignal'},
        :username => 'oursignal',
        :fullname => 'OurSignal',
        :email    => 'enquiries@oursignal.com'
      )
    end
  end
end
