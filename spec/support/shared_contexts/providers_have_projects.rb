RSpec.shared_context "providers with projects" do

  let(:sigmund_auth) do
    {
        basecamp: {

        }
    }
  end

  let(:stubbed_projects) do
    [
        Sigmund::Project.new(provider: :basecamp, uid: 'stubbed-001', name: "Project #1"),
        Sigmund::Project.new(provider: :basecamp, uid: 'stubbed-002', name: "Project #2"),
        Sigmund::Project.new(provider: :basecamp, uid: 'stubbed-003', name: "Project #3"),
    ]
  end

  before do
    fake_provider = double("basecamp provider", fetch: stubbed_projects)
    allow(Sigmund::Providers::Basecamp).to receive(:new).and_return(fake_provider)
  end



end