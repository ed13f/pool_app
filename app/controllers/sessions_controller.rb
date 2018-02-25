class SessionsController < ApplicationController
	include SessionsHelper
    def index
      root_redirect_path
    end

  	def new
      if session[:business_id] || session[:user_id]
        root_redirect_path
      else
    	  @user = User.new
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
