require "spec_helper"


module Sigmund
  module Providers::Basecamp
    RSpec.describe OauthHelper do

      subject do
        described_class.new(client_id: client_id, client_secret: client_secret)
      end

      describe "#oauth_url" do

        it "provides an url to basecamp auth screen" do

          result = subject.oauth_url(redirect_url: redirect_url)

          expect(result).to start_with("https://launchpad.37signals.com/authorization/new")
          expect(result).to include("redirect_uri=#{CGI.escape(redirect_url)}")
          expect(result).to include("client_id=#{CGI.escape(client_id)}")
          expect(result).to include("type=web_server")
        end

      end

      describe "#access_token_for_oauth_callback_request" do

        before do
          stub_request(:post, %r|https://launchpad.37signals.com/authorization/token|)
              .and_return(
                  headers: {
                      "Content-Type" => "application/json"
                  },
                  body: oauth_token_body
              )
        end

        it "sends the expected request" do
          subject.access_token_for_oauth_callback_request(callback_request)


          expect(WebMock).to have_requested(:post, "https://launchpad.37signals.com/authorization/token")
                                 .with(body: hash_including("code" => oauth_code))
                                 .with(body: hash_including("type" => "web_server"))
                                 .with(body: hash_including("client_id" => client_id))
                                 .with(body: hash_including("client_secret" => client_secret))
                                 .with(body: hash_including("redirect_uri" => redirect_url))

        end


      end


      private

      let(:client_id) { "123456789" }
      let(:client_secret) { "topsecret" }
      let(:redirect_url) { "http://www.acme.com/callbacks" }
      let(:oauth_code) { "fake_oauth_code" }

      let(:callback_request) do
        double(
            "request",
            params: { code: oauth_code },
            url: "#{redirect_url}?code=#{oauth_code}",
        )
      end


      let(:oauth_token_body) {
        {
            "access_token" => "fake_access_token"
        }.to_json
      }

    end
  end
end