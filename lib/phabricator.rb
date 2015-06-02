require 'phabricator/config'
require 'phabricator/version'
require 'phabricator/logging'

module Phabricator
  extend Phabricator::Config
end

require 'phabricator/conduit_client'
require 'phabricator/maniphest'
require 'phabricator/project'
require 'phabricator/user'
require 'phabricator/core/comment'
require 'phabricator/maniphest/task'
