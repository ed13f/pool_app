class UsersController < ApplicationController
  include UsersHelper
    def index
      @pools = @user.customers.search(params[:search])
    end
  	def new
      @logged_in_user = User.find_by_id(session[:user_id])
      user_allow_business_and_admin
    	@user = User.new
      respond_to do |format|
        format.js { render partial: "users/ajax_show_form", locals: {user: @user} }
      end
  	end

  	def create
      @logged_in_user = User.find_by_id(session[:user_id])
      user_allow_business_and_admin
    	  @user = User.new(user_params)
        @user.business_id = assign_business_id
        @user.phone = user_params[:phone].gsub(/[^\d]/, '')
    	  if @user.save
      		# UserMailer.welcome_email(@user).deliver
      		respond_to do |format|
            format.js { render partial: "users/ajax_create_form", locals: {user: @user} }
          end
    	  else
          @errors = @user.errors.messages.keys
          @errors = {user: @errors}
          respond_to do |format|
            format.js { render partial: "application/ajax_error_handling", locals: {errors: @errors} }
          end
    	  end
  	end

  	def show
    	@user = User.find_by_id(params[:id])
      @logged_in_user = User.find_by_id(session[:user_id])
      @note = Note.new
      user_allow_user_business_and_admin
      if @user
        # @pools = @user.customers
        @pools = customer_search(params[:search], @user.customers)
        @todays_route = customer_search(params[:search], todays_route)
        @sidebar_todays_route = todays_route
        
        if(!params[:search].nil? && !params[:button].nil?)
          respond_to do |format|
            format.html {render or redirect_to wherever you need it}
            format.js { render partial: "users/search_result", locals: {user: @user} }
          end
        end
        
      end
    end

  	def edit
    	@user = User.find_by_id(params[:id])
      @logged_in_user = User.find_by_id(session[:user_id])
      user_allow_user_business_and_admin
      respond_to do |format|
        format.js { render partial: "users/ajax_show_form", locals: {user: @user} }
      end
  	end

  	def update
      @user  = User.find_by_id(params[:id])
      @logged_in_user = User.find_by_id(session[:user_id])
      user_allow_user_business_and_admin
  	  if @user.update_attributes(user_params)
        respond_to do |format|
          format.js { render partial: "users/ajax_update_form", locals: {user: @user} }
        end
      else
        flash[:notice] = "Enter Required Feilds(*)"
        respond_to do |format|
          format.js { render partial: "users/ajax_update_form", locals: {user: @user} }
        end
      end
  	end

   def destroy
    @user = User.find_by_id(params[:id])
    if session[:business_id] && @user.customers.length == 0
      # @user.destroy
      @user.active_employee = false
      @user.save
      redirect_to "/"
    else
      flash[:notice] = "Not authorized / Transfer remaining customers"
      redirect_back(fallback_location: root_path)
    end
  end

  	private
  	def user_params
    	params.require(:user).permit(:first_name, :last_name, :email, :password, :admin, :phone, :user_id)
  	end
end
