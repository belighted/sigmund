require 'oauth2'

module Sigmund
  module Providers::Basecamp

     class OauthHelper

       def self.from_config
         client_id = Sigmund.sigmund_config.basecamp3_oauth_client_id
         client_secret = Sigmund.sigmund_config.basecamp3_oauth_client_secret
         new(client_id: client_id, client_secret: client_secret)
       end


       def initialize(client_id:, client_secret: )
         @client = OAuth2::Client.new(
             client_id,
             client_secret,
             :site => 'https://launchpad.37signals.com',
             authorize_url: '/authorization/new',
             token_url: '/authorization/token'
         )
       end

       def basecamp_oauth_url(redirect_url: )
         client.auth_code.authorize_url(
             :redirect_uri => redirect_url,
             type: 'web_server',
         )
       end

       def access_token_for_oauth_callback_request(request)
         assert_no_error(request)

         token = client.auth_code.get_token(
             request.params.fetch(:code),
             :redirect_uri =>  (request.base_url + request.path),
             type: 'web_server',
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