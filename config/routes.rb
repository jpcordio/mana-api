require 'api_constraints'

Rails.application.routes.draw do

  root 'application#health_check'

  # match "*path", to: "application#route_not_found", via: :all

  namespace :api, defaults: { format: :json } do
    mount_devise_token_auth_for 'User', at: 'auth'

    scope module: :v1,
          constraints: ApiConstraints.new(version: 1, default: false) do
      resources :articles
    end

    scope module: :v2,
          constraints: ApiConstraints.new(version: 2, default: true) do
      resources :articles
    end
  end
end

# Example:
# blog/api/v1/article: default = false version = 1
# blog/api/v2/article: default = true version = 2

# blog/api/articles
