require "tracker_api"

module Sigmund
  module Providers::Pivotal


    class Fetcher

      PROVIDER_CODE = :pivotal

      def initialize(api_token:)
        @client = TrackerApi::Client.new(token: api_token)
      end

      def fetch
        client.projects(fields: "name").map do |project|
          Project.new(provider: PROVIDER_CODE, uid: project.id, name: project.name, url: nil)
        end
      rescue Faraday::ClientError => e
        raise Error.new(e.message)
      end

      private

      attr_reader :client


    end

  end
end