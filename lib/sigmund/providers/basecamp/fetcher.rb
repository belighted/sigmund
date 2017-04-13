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
      account_base_urls.flat_map do |account_base_url|
        fetch_page_and_next("#{account_base_url}/projects.json")
      end
    end

    private

    attr_reader :access_token

    def account_base_urls
      return @account_base_urls if @account_base_urls

      response = http_connection.get("https://launchpad.37signals.com/authorization.json")
      @account_base_urls = response.body["accounts"]
                               .select{|account|  ["bc3", "bc2", "bcx"].include? account["product"]  }
                               .map{|account|  account["href"]  } # https://github.com/basecamp/api/blob/master/sections/authentication.md#get-authorization
    end

    def fetch_page_and_next(maybe_url)
      return [] if maybe_url.blank?

      response = http_connection.get(maybe_url)

      page_projects = parse_page(response.body)

      next_page = response.headers["Link"]
      page_projects + fetch_page_and_next(next_page) # https://github.com/basecamp/bc3-api/blob/master/README.md#pagination
    end

    def parse_page(body)
      body.map do |project|
        Project.new(provider: PROVIDER_CODE, uid: project['id'], name: project['name'], url: project['app_url'])
      end
    end



    def http_connection
      @http_connection ||= Faraday.new do |faraday|


        faraday.request :oauth2, access_token, token_type: 'bearer'
        faraday.headers['User-Agent'] = Sigmund.user_agent
        faraday.headers['Content-Type'] = 'application/json'

        # faraday.response :logger                  # log requests to STDOUT
        faraday.response :json


        faraday.adapter  Faraday.default_adapter  # make requests with Net::HTTP


      end
    end

  end

  end
end