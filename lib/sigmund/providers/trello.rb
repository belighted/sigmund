require "faraday"
require "faraday_middleware"

module Sigmund
  class Providers::Trello
    PROVIDER_CODE = :trello
    
    def initialize(app_key:, api_token:, account_id:)
      @app_key = app_key
      @api_token = api_token
      @account_id = account_id
    end
    
    def fetch
      response = http_connection.get("boards")
      response.body.map do |board|
        Project.new(provider: PROVIDER_CODE, uid: board['id'], name: board['name'], url: board['url'])
      end
    end
    
    private

    attr_reader :app_key, :api_token, :account_id

    def http_connection
      @http_connection ||= Faraday.new(
          :url => "https://api.trello.com/1/organizations/#{account_id}",
      )  do |faraday|

        faraday.params[:key] = app_key
        faraday.params[:token] = api_token
        faraday.headers['Content-Type'] = 'application/json'

        faraday.response :logger                  # log requests to STDOUT
        faraday.response :json, :content_type => /\bjson$/

        faraday.adapter  Faraday.default_adapter  # make requests with Net::HTTP

      end
    end

    
  end
end