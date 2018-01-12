class SessionsController < ApplicationController
	include SessionsHelper
  	def new
    	@user = User.new
  	end

  	def create
    	@user = User.find_by(email: params[:email])
    	if @user && @user.authenticate(params[:password])
     		session[:business_id] = @user.business.id
      		log_in @user
      		redirect_to @user
    	else
      		flash.now[:danger] = 'Invalid email/password combination'
      		render 'new'
    	end
  	end

  	def destroy
    	log_out
    	redirect_to '/users/new'
  	end
end
