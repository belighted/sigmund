require "faraday"
require "faraday_middleware"

module Sigmund
  class Providers::Trello::Fetcher

    PROVIDER_CODE = :trello
    
    def initialize(app_key:, api_token:)
      @app_key = app_key
      @api_token = api_token
    end
    
    def fetch
      response = http_connection.get("organizations/#{account_id}/boards")

      response.body.map do |board|
        Project.new(provider: PROVIDER_CODE, uid: board['id'], name: board['name'], url: board['url'])
      end
    rescue Faraday::ClientError => e
      raise Error.new(e.message)
    end
    
    private

    attr_reader :app_key, :api_token

    def account_id
      return @account_id if @account_id
      response = http_connection.get("members/me/organizations")
      @account_id = response.body.first["id"]
    rescue Faraday::ClientError => e
      raise Error.new(e.message)
    end

    def http_connection
      @http_connection ||= Faraday.new ("https://api.trello.com/1") do |faraday|

        faraday.params[:key] = app_key
        faraday.params[:token] = api_token
        faraday.headers['Content-Type'] = 'application/json'

        faraday.response :logger                  # log requests to STDOUT
        faraday.response :json, :content_type => /\bjson$/
        faraday.response :raise_error

        faraday.adapter  Faraday.default_adapter  # make requests with Net::HTTP

      end
    end

    
  end
end