require "octokit"

module Sigmund
  module Providers::Github

    class Fetcher

      PROVIDER_CODE = :github

      def self.for_oauth_callback_request(request)
        access_token = OauthHelper.from_config.access_token_for_oauth_callback_request(request)
        new(access_token: access_token)
      end


      def initialize(access_token:)
        @octokit_client = Octokit::Client.new(
            :access_token => access_token,
            :user_agent => Sigmund.user_agent,
        )
      end

      def fetch
        repos = octokit_client.repositories
        repos.map do |repo|
          Project.new(provider: PROVIDER_CODE, uid: repo.id, name: repo.name, url: repo.html_url)
        end

      end

      private

      attr_reader :octokit_client

    end

  end
end