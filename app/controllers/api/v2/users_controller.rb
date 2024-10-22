# app/controllers/api/v2/users_controller.rb
class Api::V2::UsersController < ApplicationController

    # Search users that is a company (role = true) and if the user follow it already or not
      def all_companies
        companies = User.where(role: true)
        render json: companies, status: :ok
      end
end
