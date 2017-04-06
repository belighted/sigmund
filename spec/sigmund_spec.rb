require "spec_helper"

require "support/shared_contexts/providers_have_projects"

RSpec.describe Sigmund do

  it "has a version number" do
    expect(Sigmund::VERSION).not_to be nil
  end


  context "with stubbed third parties" do

    include_context "providers with projects"

    it "returns a list of Projects" do

      client = Sigmund::Client.new(sigmund_auth)
      projects = client.fetch_all

      expect(projects.first).to be_a(Sigmund::Project)
      expect(projects.size).to eq stubbed_projects.size
    end


  end




end
