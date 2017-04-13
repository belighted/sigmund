require "spec_helper"


module Sigmund
  module Providers::Github
    RSpec.describe Fetcher do

      subject do
        described_class.new(access_token: access_token)
      end

      before do
        stub_request(:get, %r|https://api.github.com/user/repos|).to_return(
            body: repositories_body,
            headers: {
                "Content-Type" => "application/json"
            }
        )
      end

      describe "#fetch" do

        it "sends the correct API request" do
          subject.fetch

          expect(WebMock).to have_requested(:get, "https://api.github.com/user/repos")
                                  .with(query: hash_including()) # anything
                                  .with(headers: { "Authorization" => "token #{access_token}" })
                                  .with(headers: { "User-Agent" => "Sigmund (https://github.com/belighted/sigmund)" })
        end

        it "parses correctly the response" do
          projects = subject.fetch
          project = projects.first


          expect(project.provider).to eq :github
          expect(project.uid).to be_present
          expect(project.name).to be_present
        end



      end


      private

      let(:access_token) { "123456789" }

      let(:repositories_body) {
        [
            {
                "id" => "abcd1234",
                "name" => "test project",
                "html_url" => "http://www.google.com",
            }
        ].to_json
      }

    end
  end
end