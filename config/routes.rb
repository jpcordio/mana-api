require 'api_constraints'

Rails.application.routes.draw do

  resources :connections
  root 'application#health_check'

  namespace :api, defaults: { format: :json } do
    mount_devise_token_auth_for 'User', at: 'auth', controllers: {
      registrations: 'overrides/registrations',
      passwords: 'devise_token_auth/passwords'
    }

    scope module: :v1,
          constraints: ApiConstraints.new(version: 1, default: false) do
      resources :articles
    end

    scope module: :v2,
          constraints: ApiConstraints.new(version: 2, default: true) do
          get 'articles/user/:user_id', to: 'articles#user_articles'
      resources :articles
    end
  end




end