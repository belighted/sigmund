require 'oauth2'
require "addressable/uri"

module Sigmund
  module Providers::Github

     class OauthHelper

       AUTHORIZE_URL = "https://github.com/login/oauth/authorize"
       TOKEN_URL = "https://github.com/login/oauth/access_token"

       include GenericOauthHelper

       def self.from_config
         client_id = Sigmund.sigmund_config.github_oauth_client_id
         client_secret = Sigmund.sigmund_config.github_oauth_client_secret
         new(client_id: client_id, client_secret: client_secret)
       end


       def initialize(client_id:, client_secret: )
         @client = OAuth2::Client.new(
             client_id,
             client_secret,
             authorize_url: AUTHORIZE_URL,
             token_url: TOKEN_URL,
         )
       end

       def oauth_url(redirect_url: )
         client.auth_code.authorize_url(
             redirect_uri: redirect_url,
             scope: "repo"
         )
       end

       def access_token_for_oauth_callback_request(request)
         assert_no_error(request)

         redirect_uri = redirect_uri_for(request)
         code = request.params.fetch(:code)

         client.auth_code
             .get_token(
                 code,
                 redirect_uri: redirect_uri ,
                 headers: { "Accept" => "application/json" }
             )
             .token
       end

       private

       attr_reader :client, :client_id, :client_secret

     end
  end
end