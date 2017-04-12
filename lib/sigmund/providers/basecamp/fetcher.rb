require "faraday"
require "faraday_middleware"

module Sigmund
  module Providers::Basecamp

    class Fetcher

    PROVIDER_CODE = :basecamp

    def self.for_oauth_callback_request(request)
      access_token = OauthHelper.from_config.access_token_for_oauth_callback_request(request)
      new(access_token: access_token)
    end


    def initialize(access_token: )
      @access_token = access_token
    end

    def fetch
      response = http_connection.get("#{account_base_url}/projects.json")

      response.body.map do |project|
        Project.new(provider: PROVIDER_CODE, uid: project['id'], name: project['name'], url: project['app_url'])
      end
    end

    private

    attr_reader :access_token

    def account_base_url
      return @account_base_url if @account_base_url

      response = http_connection.get("https://launchpad.37signals.com/authorization.json")
      account = response.body["accounts"].detect{|account|
        ["bc3", "bc2", "bcx"].include? account["product"]
      }
      @account_base_url = account["href"] # https://github.com/basecamp/api/blob/master/sections/authentication.md#get-authorization
    end

    def http_connection
      @http_connection ||= Faraday.new do |faraday|


        faraday.request :oauth2, access_token, token_type: 'bearer'
        faraday.headers['User-Agent'] = 'Sigmund (https://github.com/belighted/sigmund)'
        faraday.headers['Content-Type'] = 'application/json'

        faraday.response :logger                  # log requests to STDOUT
        faraday.response :json


        faraday.adapter  Faraday.default_adapter  # make requests with Net::HTTP


      end
    end

  end

  end
end