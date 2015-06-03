require_relative 'phabricator/config'
require_relative 'phabricator/version'
require_relative 'phabricator/logging'

module Phabricator
  extend Phabricator::Config
end

require_relative 'phabricator/conduit_client'
require_relative 'phabricator/maniphest'
require_relative 'phabricator/project'
require_relative 'phabricator/user'
require_relative 'phabricator/core/comment'
require_relative 'phabricator/maniphest/task'
