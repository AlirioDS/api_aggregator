class UserController < ApplicationController
    def obtain_user_status
        result = UserStatusService.new(params[:id]).call
        
        if result[:error]
            render json: result, status: :not_found
        else
            render json: result
        end
    end
end