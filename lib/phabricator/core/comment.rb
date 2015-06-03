require 'date'

module Phabricator::Core
  class Comment
    attr_reader :text, :transactionPHID
    def initialize(attributes)
      @taskID = attributes['taskID']
      @dateCreated = attributes['dateCreated']  # UNIX timestamp
      @text = attributes['comments']
      @authorPHID = attributes['authorPHID']

      # This value might be needed for feed webhook pushes
      @transactionPHID = attributes['transactionPHID']
    end

    def author
      Phabricator::User.find_by_phid(@authorPHID)
    end

    def transaction_phid
      @transactionPHID
    end

    def date_created
      Time.at(@dateCreated.to_i).to_datetime
    end
    alias_method :created_at, :date_created   # For Rails parity
  end
end