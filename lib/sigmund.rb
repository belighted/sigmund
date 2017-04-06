require "sigmund/version"

require 'active_support'
require 'active_support/core_ext'
require 'active_support/dependencies'

ActiveSupport::Dependencies.autoload_paths << File.dirname(__FILE__)
ActiveSupport::Dependencies.autoload_once_paths << File.dirname(__FILE__)

module Sigmund
  # Your code goes here...
end
