module Api
  module V1
    class BaseApiController < ApplicationController

      def current_user
        current_user = User.first
        binding.pry
        current_user
      end

    end
  end
end
