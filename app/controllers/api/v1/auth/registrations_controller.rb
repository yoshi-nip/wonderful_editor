module Api
  module V1
    module Auth
      class RegistrationsController < DeviseTokenAuth::RegistrationsController

        private

          def sign_up_params
            params.require(:user).permit(:name, :email, :password, :password_confirmation)
            # params.require(:registration).permit(:email, :password)
          end

          def account_update_params
            params.require(:user).permit(:name, :email)
          end
      end
    end
  end
end
