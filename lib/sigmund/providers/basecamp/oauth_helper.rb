require 'oauth2'
require "addressable/uri"

module Sigmund
  module Providers::Basecamp
     class OauthHelper

       AUTHORIZE_URL = "https://launchpad.37signals.com/authorization/new"
       TOKEN_URL = "https://launchpad.37signals.com/authorization/token"

       include GenericOauthHelper

       def self.from_config
         client_id = Sigmund.sigmund_config.basecamp3_oauth_client_id
         client_secret = Sigmund.sigmund_config.basecamp3_oauth_client_secret
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
             :redirect_uri => redirect_url,
             type: 'web_server',
         )
       end

       def access_token_for_oauth_callback_request(request)
         assert_no_error(request)

         client.auth_code
             .get_token(
                 request.params.fetch(:code),
                 redirect_uri: redirect_uri_for(request) ,
                 type: 'web_server',
             )
             .token
       end

       private

       attr_reader :client, :client_id, :client_secret

     end
  end
end