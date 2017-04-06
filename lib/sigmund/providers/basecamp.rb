require "faraday"

module Sigmund
  class Providers::Basecamp
    
    def initialize(account_id:, api_key: )
      @account_id = account_id 
      @api_key = api_key 
    end
    
    def fetch
      response = http_connection.get("projects.json")
    end
    
    private

    attr_reader :account_id, :api_key

    def http_connection
      @http_connection ||= Faraday.new(
          :url => "https://basecamp.com/#{account_id}/api/v1",
      )  do |faraday|

        faraday.use Faraday::Request::BasicAuthentication, api_key, 'X'
        faraday.headers['User-Agent'] = 'Sigmund (https://github.com/belighted/sigmund)'
        faraday.headers['Content-Type'] = 'application/json'

        faraday.response :logger                  # log requests to STDOUT
        faraday.adapter  Faraday.default_adapter  # make requests with Net::HTTP


      end
    end

    
  end
end