class ApplicationController < ActionController::API
        include DeviseTokenAuth::Concerns::SetUserByToken

        before_action :configure_permitted_parameters, if: :devise_controller?

        def health_check
                render json: { message: 'API is running' }, status: :ok
        end

        # def route_not_found
        #         render json: { error: 'Not Found' }, status: :not_found
        # end

        protected

        def configure_permitted_parameters
                devise_parameter_sanitizer.permit(:account_update, keys: %i[name nickname])
        end
end
