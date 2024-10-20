module Overrides
  class RegistrationsController < DeviseTokenAuth::RegistrationsController
    private

    def sign_up_params
      params.require(:registration).permit(:email, :password, :password_confirmation, :role, :name)
    end

#     def account_update_params
#       params.require(:user).permit(:email, :password, :password_confirmation, :name)
#     end
  end
end