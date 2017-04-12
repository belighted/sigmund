require "spec_helper"


module Sigmund
  RSpec.describe Providers::Basecamp::Fetcher do

    subject do
      Providers::Basecamp::Fetcher.new(access_token: access_token)
    end

    before do
      stub_request(:get, %r|https://launchpad.37signals.com/authorization.json|).to_return(body: basecamp_authorization_body)
      stub_request(:get, %r|#{account_base_url}/projects.json|).to_return(body: projects_body)
    end

    describe "#fetch" do

      it "sends the correct API request" do
        subject.fetch

        expect(WebMock).to have_requested(:get, "#{account_base_url}/projects.json")
            .with(headers: { "Authorization" => "Bearer #{access_token}"})
            .with(headers: { "User-Agent" => "Sigmund (https://github.com/belighted/sigmund)" } )
      end

      it "parses correctly the response" do
        projects =  subject.fetch
        project = projects.first


        expect(project.provider).to eq :basecamp
        expect(project.uid).to be_present
        expect(project.name).to be_present
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