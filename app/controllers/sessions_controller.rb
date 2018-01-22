class SessionsController < ApplicationController
	include SessionsHelper
    def index
      if session[:bussiness_id]
        redirect_to :controller => 'businesses', :action => 'show', id: session[:business_id]
      elsif session[:user_id]
        redirect_to :controller => 'users', :action => 'show', id: session[:user_id]
      else
        redirect_to :controller => 'sessions', :action => 'new'
      end
    end

  	def new
    	@user = User.new
  	end

  	def create
      if params[:type] == "user"
      	@user = User.find_by(email: params[:email])
      	if @user && @user.authenticate(params[:password])
        		log_in @user
        		redirect_to @user
      	else
        		flash.now[:danger] = 'Invalid email/password combination'
        		render 'new'
      	end
      elsif params[:type] == "business"
        @business = Business.find_by(email: params[:email])
        if @business && @business.authenticate(params[:password])
          session[:business_id] = @business.id
            redirect_to @business
        else
            flash.now[:danger] = 'Invalid email/password combination'
            render 'new'
        end
      else
        render 'new'
      end

  	end

  	def destroy
    	log_out
    	redirect_to '/'
  	end
end
