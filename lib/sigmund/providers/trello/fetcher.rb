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
      http_connection
          .get("members/me/boards?filter=open&fields=name,url")
          .body
          .map { |board| build_project_from_board(board) }

    rescue Faraday::ClientError => e
      raise Error.new(e.message)
    end
    
    private

    attr_reader :app_key, :api_token

    def build_project_from_board(board)
      Project.new(
          provider: PROVIDER_CODE,
          uid: board['id'],
          name: board['name'],
          url: board['url']
      )
    end


    def http_connection
      @http_connection ||= build_http_connection
    end

    def build_http_connection
      Faraday.new("https://api.trello.com/1") do |faraday|
        setup_faraday_request(faraday)
        setup_faraday_response(faraday)
        faraday.adapter  Faraday.default_adapter
      end
    end

    def setup_faraday_request(faraday)
      faraday.params[:key] = app_key
      faraday.params[:token] = api_token
      faraday.headers['Content-Type'] = 'application/json'
    end

    def setup_faraday_response(faraday)
      # faraday.response :logger                  # log requests to STDOUT
      faraday.response :json, :content_type => /\bjson$/
      faraday.response :raise_error
    end

    
  end
end