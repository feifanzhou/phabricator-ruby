require 'phabricator/conduit_client'
require 'phabricator/project'
require 'phabricator/user'

module Phabricator::Maniphest
  class Task
    module Priority
      class << self
        # TODO: Make these priority values actually correct, or figure out
        # how to pull these programmatically.
        PRIORITIES = {
          unbreak_now: 100,
          needs_triage: 90,
          high: 80,
          normal: 50,
          low: 25,
          wishlist: 0
        }

        PRIORITIES.each do |priority, value|
          define_method(priority) do
            value
          end
        end
      end
    end

    attr_reader :id
    attr_accessor :title, :description, :priority

    def self.find_by_id(task_id)
      # TODO: Cache results
      response = client.request('maniphest.info', {
        task_id: task_id
      })

      data = response['result']
      self.new(data)
    end

    def self.create(title, description=nil, projects=[], priority='normal', owner=nil, ccs=[], other={})
      response = client.request('maniphest.createtask', {
        title: title,
        description: description,
        priority: Priority.send(priority),
        projectPHIDs: projects.map {|p| Phabricator::Project.find_by_name(p).phid },
        ownerPHID: owner ? Phabricator::User.find_by_name(owner).phid : nil,
        ccPHIDs: ccs.map {|c| Phabricator::User.find_by_name(c).phid }
      }.merge(other))

      data = response['result']

      # TODO: Error handling

      self.new(data)
    end

    def initialize(attributes)
      @id = attributes['id']
      @title = attributes['title']
      @description = attributes['description']
      @priority = attributes['priority']
    end

    def comments
      response = client.request('maniphest.gettasktransactions', {
        ids: [self.id]
      })

      data = response['result']
      comments_data = data.select { |entry| entry['transactionType'] == 'core:comment' }
      comments_data.map { |comment_data| Phabricator::Core::Comment.new(comment_data) }
    end

    def add_comment(comment)
      response = client.request('maniphest.update', {
        id: self.id,
        comments: (comment.is_a? Phabricator::Core::Comment) ? comment.text : comment
      })
      # Result is JSON of the task itself. Not much we can do with it here
      response['result']
    end

    private

    def self.client
      @client ||= Phabricator::ConduitClient.instance
    end
  end
end
