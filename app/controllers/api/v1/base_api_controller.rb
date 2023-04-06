module Api
  module V1
    class BaseApiController < ApplicationController
      include DeviseTokenAuth::Concerns::SetUserByToken

      def current_user
        User.first
      end
    end
  end
end
