require 'oauth2'
require "addressable/uri"

module Sigmund
  module Providers::Github

     class OauthHelper

       AUTHORIZE_URL = "https://github.com/login/oauth/authorize"
       TOKEN_URL = "https://github.com/login/oauth/access_token"

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

         redirect_uri = Addressable::URI.parse(request.url)

         params = redirect_uri.query_values || {}
         params.delete('code')

         redirect_uri.query_values = params.any? ? params : nil


         token = client.auth_code.get_token(
             request.params.fetch(:code),
             :redirect_uri =>  redirect_uri.to_s ,
             headers: {
                 "Accept" => "application/json"
             }
         )

         token.token
       end

       private

       attr_reader :client, :client_id, :client_secret

       def assert_no_error(request)
         return unless request.params.key?('error')
         raise Error.new(request.params['error'])
       end



     end




  end
end