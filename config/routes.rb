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

            # New view for article per user
            get 'articles/user/:user_id', to: 'articles#user_articles'
            # New view for articles per user that follows it
            get 'articles/followed', to: 'articles#followed_articles'
            resources :articles


            # Route to get all companies
            get 'all_companies', to: 'users#all_companies'

            # Routes for Connection
            resources :connections, only: [:create, :index, :update]

            # Get if user follows a specific company per id
            get 'users/following_company/:company_id', to: 'connections#following_company', as: 'following_company'

            # Get all companies followed
            get 'users/followed_companies', to: 'users#followed_companies'

            # Show profile per ID
            # Route to edit profile
            get 'profile/company/:user_id', to: 'profile#show_company_by_user'
            put 'profile/company/:id', to: 'profile#update_company'
            post 'profile/company', to: 'profile#create_company'
            resources :companies, only: [:create, :update]

            # Route for follow/unfollow companies
            resources :users do
              post 'follow', to: 'connections#create'
              delete 'unfollow/:company_id', to: 'connections#destroy', as: 'unfollow_company', on: :collection
      end
    end

  end
end
