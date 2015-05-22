require 'phabricator/conduit_client'
require 'phabricator/user'

module Phabricator::Core
  class Comment
    attr_reader :text
    def initialize(attributes)
      @taskID = attributes['taskID']
      @dateCreated = attributes['dateCreated']  # UNIX timestamp
      @text = attributes['comments']
      @authorPHID = attributes['authorPHID']
    end

    def author
      Phabricator::User.find_by_phid(@authorPHID)
    end
  end
end