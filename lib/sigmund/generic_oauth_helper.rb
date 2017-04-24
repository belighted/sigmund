require 'oauth2'
require "addressable/uri"

module Sigmund
  module GenericOauthHelper

    def assert_no_error(request)
      return unless request.params.key?('error')
      raise Error.new(request.params['error'])
    end

    def redirect_uri_for(request)
      redirect_uri = Addressable::URI.parse(request.url)

      params = redirect_uri.query_values || {}
      params.delete('code')

      redirect_uri.query_values = params.any? ? params : nil
      redirect_uri
    end

  end
end