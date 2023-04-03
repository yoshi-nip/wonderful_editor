module Api
  module V1
    class BaseApiController < ApplicationController
      def current_user
        User.first
      end
    end
  end
end
