require "sigmund/version"

require 'active_support'
require 'active_support/core_ext'
require 'active_support/dependencies'

ActiveSupport::Dependencies.autoload_paths << File.dirname(__FILE__)
ActiveSupport::Dependencies.autoload_once_paths << File.dirname(__FILE__)

module Sigmund
  Error = Class.new(StandardError)

  def self.user_agent
    'Sigmund (https://github.com/belighted/sigmund)'
  end

  def self.basecamp_oauth_url(redirect_url:)
    Providers::Basecamp::OauthHelper.from_config.oauth_url(redirect_url: redirect_url)
  end

  def self.github_oauth_url(redirect_url:)
    Providers::Github::OauthHelper.from_config.oauth_url(redirect_url: redirect_url)
  end


  def self.sigmund_config
    Rails.application.config.x.sigmund
  end



end
