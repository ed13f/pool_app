class UsersController < ApplicationController
  include UsersHelper
  	def new
      @logged_in_user = User.find_by_id(session[:user_id])
      user_allow_business_and_admin
    	  @user = User.new
  	end

  	def create
      @logged_in_user = User.find_by_id(session[:user_id])
      user_allow_business_and_admin
    	  @user = User.new(user_params)
        @user.business_id = assign_business_id
    	  if @user.save
      		UserMailer.welcome_email(@user).deliver
      		redirect_to user_path(@user)
    	  else
      		flash[:notice] = @user.errors.full_messages
          redirect_to '/users/new'
    	  end
  	end

  	def show
    	@user = User.find_by_id(params[:id])
      @logged_in_user = User.find_by_id(session[:user_id])
      user_allow_user_business_and_admin
      if @user
        @pools = @user.customers
        @finished_route = select_finished_route
        @unfinished_route = select_unfinished_route
      end
        @hash = Gmaps4rails.build_markers(@pools) do |customer, marker|
          marker.lat customer.latitude
          marker.lng customer.longitude
          marker.infowindow render_to_string(:partial => "/customers/map_customer_info.html.erb", :locals => { :object => customer})
        end
    end

  	def edit
    	@user = User.find_by_id(params[:id])
      @logged_in_user = User.find_by_id(session[:user_id])
      user_allow_user_business_and_admin
  	end

  	def update
      @user  = User.find_by_id(params[:id])
      @logged_in_user = User.find_by_id(session[:user_id])
      user_allow_user_business_and_admin
  	  if @user.update_attributes(user_params)
        redirect_to action:'show', :id => @user.id
      else
        flash[:notice] = "Fill in all required fields"
        redirect_to '/users/new'
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
