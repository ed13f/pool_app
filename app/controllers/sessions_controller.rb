class SessionsController < ApplicationController
	include SessionsHelper
    def index
      # session[:business_id] = 1
      root_redirect_path
    end

  	def new
      # binding.pry
      if session[:business_id] || session[:user_id]
        root_redirect_path
      else
        @session = User.new
      end  
  	end

  	def create
      if params[:type] == "user"
        authenticate_signin(@user, User, :user_id)
      elsif params[:type] == "business"
        authenticate_signin(@business, Business, :business_id)
      else
        flash[:notice] = "Please Select An Account Type"
        redirect_to '/new'
      end
  	end

  	def destroy
    	log_out
    	root_redirect_path
  	end
end
