class SessionsController < ApplicationController
	include SessionsHelper
    def index
      root_redirect_path
    end

  	def new
    	@user = User.new
  	end

  	def create
      if params[:type] == "user"
        authenticate_signin(@user, User, :user_id)
      elsif params[:type] == "business"
        authenticate_signin(@business, Business, :business_id)
      else
        render 'new'
      end
  	end

  	def destroy
    	log_out
    	root_redirect_path
  	end
end
