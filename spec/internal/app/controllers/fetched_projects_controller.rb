class FetchedProjectsController < ApplicationController


  def index
    fetcher =  build_fetcher
    projects = fetcher.fetch

    @projects = projects
  rescue Sigmund::Error
    redirect_to root_url
  end

  private

  attr_reader :projects
  helper_method :projects

  def build_fetcher
    provider_param = params[:provider]
    self.send "build_#{provider_param}_fetcher"
  end

  def build_basecamp_fetcher
    Sigmund::Providers::Basecamp::Fetcher.for_oauth_callback_request(request)
  end

  def build_github_fetcher
    Sigmund::Providers::Github::Fetcher.for_oauth_callback_request(request)
  end


  def build_trello_fetcher
    app_key = params[:trello_app_key]
    api_token = params[:trello_api_token]

    Sigmund::Providers::Trello::Fetcher.new(app_key: app_key, api_token: api_token)
  end



end