require 'phabricator/conduit_client'

module Phabricator
  class User
    @@cached_users_by_phid = {}
    @@cached_users_by_name = {}

    attr_reader :phid
    attr_accessor :name, :email

    def self.populate_all
      response = client.request('user.query')

      response['result'].each do |data|
        user = User.new(data)
        @@cached_users_by_phid[user.phid] = user
        @@cached_users_by_name[user.name] = user
      end

    end

    def self.find_by_name(name)
      # Re-populate if we couldn't find it in the cache (this applies to
      # if the cache is empty as well).
      populate_all unless @@cached_users_by_name[name]

      @@cached_users_by_name[name]
    end

    def self.find_by_phid(phid)
      populate_all unless @@cached_users_by_phid[phid]
      @@cached_users_by_phid[phid]
    end

    def initialize(attributes)
      @phid = attributes['phid']
      @name = attributes['userName']
      @email = attributes['primaryEmail']
    end

    private

    def self.client
      @client ||= Phabricator::ConduitClient.instance
    end
  end
end
