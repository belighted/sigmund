[![MIT Licence](https://badges.frapsoft.com/os/mit/mit.svg?v=103)](https://opensource.org/licenses/mit-license.php) [![Build Status](https://travis-ci.org/belighted/sigmund.svg?branch=master)](https://travis-ci.org/belighted/sigmund) [![Code Climate](https://codeclimate.com/github/belighted/sigmund.png)](https://codeclimate.com/github/belighted/sigmund)

# Sigmund

Sigmund is a small gem which goal is to fetch projects from different providers in order to help your app onboard their new users.

It is meant to be used in a Rails application but only in order to get some config, a future version might very easily propose a more generic way to setup the gem.


## Installation

First add the gem to your Gemfile and run the `bundle` command to install it.


```ruby
gem 'sigmund'
```

Then set the config in the different environment config `config/environment/[RAILS_ENV].rb`

```ruby

  # Basecamp Oauth application can be created here : https://integrate.37signals.com/
  config.x.sigmund.basecamp3_oauth_client_id = "BASECAMP_CLIENT_ID"
  config.x.sigmund.basecamp3_oauth_client_secret = "BASECAMP_SECRET"

  # Github Oauth application can be created here : https://github.com/settings/developers
  config.x.sigmund.github_oauth_client_id = "GITHUB_CLIENT_ID"
  config.x.sigmund.github_oauth_client_secret = "GITHUB_CLIENT_ID"
```

## Usage

The object you need to use in order to get projects are **Fetchers**. 
Each provider has its own fetcher which knows how to use the provider API and how to parse the response in order to return **Sigmund::Project** objects.

The current **Fetchers** are :

 - `Sigmund::Providers::Basecamp::Fetcher`
 - `Sigmund::Providers::Github::Fetcher`
 - `Sigmund::Providers::Trello::Fetcher`
 - `Sigmund::Providers::Pivotal::Fetcher`
 
Each fetcher must be initialized with different params and then provide a `#fetch()` method which will return an array of **Sigmund::Project** objects.

### Sigmund::Providers::Basecamp::Fetcher

The Basecamp fetcher requires an Oauth2 access token to be instanciated. 
If you have one you can call `Sigmund::Providers::Basecamp::Fetcher.new(access_token: 'XXXX'')`

If you do not have one, you can instantiate this fetcher from an Oauth callback action by passing the current request.
Sigmund has helpers to make this process easier :

In the view
```slim
<a href="<%= Sigmund.basecamp_oauth_url(redirect_url: fetched_projects_url)%>">Fetch From Basecamp</a>
```
In the controller action

```ruby
class FetchedProjectsController < ApplicationController
    def index
      fetcher = Sigmund::Providers::Basecamp::Fetcher.for_oauth_callback_request(request)
      projects = fetcher.fetch
      # do something with  projects
    end
end
```


### Sigmund::Providers::Github::Fetcher

The Github fetcher requires an Oauth2 access token to be instanciated. 
If you have one you can call `Sigmund::Providers::Github::Fetcher.new(access_token: 'XXXX'')`

If you do not have one, you can instantiate this fetcher from an Oauth callback action by passing the current request.
Sigmund has helpers to make this process easier :

In the view
```slim
<a href="<%= Sigmund.github_oauth_url(redirect_url: fetched_projects_url)%>">Fetch From Github</a>
```
In the controller action

```ruby
class FetchedProjectsController < ApplicationController
    def index
      fetcher = Sigmund::Providers::Github::Fetcher.for_oauth_callback_request(request)
      projects = fetcher.fetch
      # do something with  projects
    end
end
```

### Sigmund::Providers::Trello::Fetcher

The Trello fetche requires an API key and token to be instanciated.
A user can find his [here](https://trello.com/app-key).

Then in the controller action you can write something along :

```ruby
class FetchedProjectsController < ApplicationController
    def index
        app_key = params[:trello_app_key]
        api_token = params[:trello_api_token]
    
        fetcher = Sigmund::Providers::Trello::Fetcher.new(app_key: app_key, api_token: api_token)
        projects = fetcher.fetch
        # do something with  projects
    end
end
```

### Sigmund::Providers::Pivotal::Fetcher

The Pivotal Tracker fetche requires an API token to be instanciated.
A user can find his [here](https://www.pivotaltracker.com/profile).

Then in the controller action you can write something along :

```ruby
class FetchedProjectsController < ApplicationController
    def index
        api_token = params[:pivotal_api_token]
    
        fetcher = Sigmund::Providers::Pivotal::Fetcher.new(api_token: api_token)
        projects = fetcher.fetch
        # do something with  projects
    end
end
```

## Demo

The gem includes a demo application in `spec/internal`.
You can run it with the command `bundle exec rackup` and then go to `http://localhost:9292`

The demo app showcase how the gem is meant to be used.


## Development

After checking out the repo, run `bundle install` to install dependencies. Then, run `rake spec` to run the tests. 
You can also run `bin/console` for an interactive prompt that will allow you to experiment.

 To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/belighted/sigmund.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

