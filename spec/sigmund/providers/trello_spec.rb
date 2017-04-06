require "spec_helper"


module Sigmund
  RSpec.describe Providers::Trello do

    subject do
      Providers::Trello.new(app_key: app_key, api_token: api_token, account_id: account_id)
    end

    before do
      stub_request(:get, %r|api.trello.com/.*/boards|).to_return(body: trello_boards_body)
    end

    describe "#fetch" do

      it "sends the correct API request" do
        subject.fetch

        expect(WebMock).to have_requested(:get, "https://api.trello.com/1/organizations/#{account_id}/boards")
            .with(query:
              hash_including(
                  key: app_key,
                  token: api_token,
              )
            )
      end

      it "parses correctly the response" do

        projects = subject.fetch
        project = projects.first

        expect(project.provider).to eq :trello
        expect(project.uid).to be_present
        expect(project.name).to be_present

      end


    end


    private

    let(:app_key){ "FAKE_TRELLO_APP_KEY" }
    let(:api_token){ "FAKE_TRELLO_API_TOKEN" }
    let(:account_id){ "FAKE_TRELLO_ACCOUNT_ID" }


    let(:trello_boards_body) do
      body = <<-EOBODY
          [
            {
            "id": "4eea4ffc91e31d1746000046",            
            "name": "Example Board",
            "url": "https://trello.com/b/OXiBYZoj/example-board"
            },
            {
            "id": "4eea4ffc91e31d1746000047",            
            "name": "Example Board 2",
            "url": "https://trello.com/b/OXiBYZoj/example-board-2"
            },
            {
            "id": "4eea4ffc91e31d1746000048",            
            "name": "Example Board 3",
            "url": "https://trello.com/b/OXiBYZoj/example-board-3"
            }
            ]
      EOBODY
      JSON.parse(body)
    end

  end
end