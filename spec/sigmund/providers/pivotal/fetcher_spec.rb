require "spec_helper"


module Sigmund
  module Providers::Pivotal
  RSpec.describe Fetcher do

    subject do
      described_class.new(api_token: api_token)
    end

    before do
      stub_request(:get, %r|https://www.pivotaltracker.com/services/v5/projects|).to_return(body: pivotal_projects_body)
    end

    describe "#fetch" do

      it "sends the correct API request" do
        subject.fetch

        expect(WebMock).to have_requested(:get, "https://www.pivotaltracker.com/services/v5/projects")
                               .with(query: hash_including()) # anything (e.g. fields restriction )
                               .with(headers: {"X-Trackertoken" => api_token} )
      end

      it "parses correctly the response" do

        projects = subject.fetch
        project = projects.first

        expect(project.provider).to eq :pivotal
        expect(project.uid).to be_present
        expect(project.name).to be_present

      end


    end


    private


    let(:api_token) { "FAKE_PIVOTAL_API_TOKEN" }
    let(:pivotal_projects_body) {
      [
          {
              "id" => "abcd1234",
              "name" => "test project",
          }
      ].to_json
    }

end
  end
end