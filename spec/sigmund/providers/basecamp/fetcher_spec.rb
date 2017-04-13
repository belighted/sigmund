require "spec_helper"


module Sigmund
  module Providers::Basecamp
    RSpec.describe Fetcher do

      subject do
        described_class.new(access_token: access_token)
      end

      before do
        stub_request(:get, %q|https://launchpad.37signals.com/authorization.json|).to_return(body: basecamp_authorization_body)
        stub_request(:get, %Q|#{account_base_url}/projects.json|).to_return(body: projects_body)
      end

      describe "#fetch" do

        it "sends the correct API request" do
          subject.fetch

          expect(WebMock).to have_requested(:get, "#{account_base_url}/projects.json")
                                 .with(headers: { "Authorization" => "Bearer #{access_token}" })
                                 .with(headers: { "User-Agent" => "Sigmund (https://github.com/belighted/sigmund)" })
        end

        it "parses correctly the response" do
          projects = subject.fetch
          project = projects.first


          expect(project.provider).to eq :basecamp
          expect(project.uid).to be_present
          expect(project.name).to be_present
        end

        it "handles multiple page" do
          next_page_url = "#{account_base_url}/projects.json?page=2"
          stub_request(:get, %Q|#{account_base_url}/projects.json|)
              .to_return(
                  body: projects_body,
                  headers: {
                      "Link" => next_page_url
                  }
              )
          stub_request(:get, next_page_url)
              .to_return(
                  body: projects_body,
              )


          subject.fetch

          expect(WebMock).to have_requested(:get, next_page_url)

        end


      end


      private

      let(:access_token) { "123456789" }
      let(:account_base_url) { "http://basecamp.com/99999/api/v1" }
      let(:basecamp_authorization_body) {
        {
            "accounts" => [
                {
                    "product" => "bc3",
                    "href" => account_base_url
                }
            ]
        }.to_json
      }
      let(:projects_body) {
        [
            {
                "id" => "abcd1234",
                "name" => "test project",
                "app_url" => "http://www.google.com",
            }
        ].to_json
      }

    end
  end
end