# app/controllers/api/v2/users_controller.rb
class Api::V2::UsersController < ApplicationController

    # Search users that is a company (role = true) and if the user follow it already or not
      def all_companies
        companies = User.where(role: true)
        render json: companies, status: :ok
      end

      # Check all followed Companies
      def followed_companies
        followed_companies = current_api_user.companies_as_customer
        render json: followed_companies, status: :ok
      end
end
