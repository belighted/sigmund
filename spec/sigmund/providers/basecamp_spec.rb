require "spec_helper"


module Sigmund
  RSpec.describe Providers::Basecamp do

    subject do
      Providers::Basecamp.new(api_key: api_key, account_id: account_id)
    end

    before do
      stub_request(:get, %r|https://basecamp.com/#{account_id}/api/v1/projects.json|)
    end

    describe "#fetch" do

      it "sends the correct API request" do
        subject.fetch

        expect(WebMock).to have_requested(:get, "https://basecamp.com/#{account_id}/api/v1/projects.json")
            .with(basic_auth: [api_key, "X"])
            .with(headers: { "User-Agent" => "Sigmund (https://github.com/belighted/sigmund)" } )
      end

      it "parses correctly the response" do
        fail "We need a real response before writing this test"
      end


    end


    private

    let(:api_key){ "FAKE_API_KEY" }
    let(:account_id){ "99999999" }



  end
end