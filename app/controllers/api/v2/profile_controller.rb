class Api::V2::ProfileController < ApplicationController

  def show_company_by_user
    company = Company.find_by_user(params[:user_id])

    if company
      render json: company
    else
      render json: { error: 'Company not found' }, status: :not_found
    end
  end

end
