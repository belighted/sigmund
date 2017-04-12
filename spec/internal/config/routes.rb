Rails.application.routes.draw do
  resource :home, only: [:show]
  resources :fetched_projects, only: [:index]

  root to: "homes#show"
end
