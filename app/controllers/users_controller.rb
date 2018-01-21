class UsersController < ApplicationController
	def index
   		# @businesses = Business.all
  	end

  	def new
    	@user = User.new
    	# @employees = User.find(session[:user_id]).business.users
  	end

  	def create
    	@user = User.new(user_params)
    	# puts "HEEEREEEEEEEEE"
    	# if user_params[:user_id]
    	#   puts user_params[:user_id]
    	# else
    	#   puts "nooooooooo"
    	# end
    	@user.business_id = session[:business_id]
    	if @user.save
      		UserMailer.welcome_email(@user).deliver
      		redirect_to user_path(@user)
    	else
      		@errors = @user.errors.full_messages
      		render 'new'
    	end
  	end

  	def show
    	@user = User.find(params[:id])
    	if @user.id == session[:user_id] || User.find(session[:user_id]).admin == true
      		@pools = @user.customers
          @finished_route = @user.customers.select do |customer|
            customer.days_list.include?(Time.now.strftime("%A")) && customer.days_visited_list.include?(Time.now.strftime("%A"))
          end
          @unfinished_route = @user.customers.select do |customer|
            customer.days_list.include?(Time.now.strftime("%A")) && customer.weekly_complete == false && !customer.days_visited_list.include?(Time.now.strftime("%A"))
          end
      		# @finished_route = @user.customers.where(service_day: Time.now.strftime("%A"), weekly_complete: true )
      		# @unfinished_route = @user.customers.where(service_day: Time.now.strftime("%A"), weekly_complete: false )
      		@hash = Gmaps4rails.build_markers(@pools) do |customer, marker|
      		marker.lat customer.latitude
      		marker.lng customer.longitude
      		marker.infowindow render_to_string(:partial => "/customers/map_customer_info.html.erb", :locals => { :object => customer})
    	end
      		render 'show'
    	else
      		@errors = ['Error, not authororized']
      		redirect_with_msg = true
    	end
  	end

  	def edit
    	@user = User.find(params[:id])
  	end

  	def update
    	@user = User.find(params[:id])
    	@user.update_attributes(user_params)
    	redirect_to action:'show', :id => @user.id
  	end

  	def route
    	@user = User.find(session[:user_id])
    	# binding.pry
    	@finished_route = @user.customers.where(service_day: Time.now.strftime("%A"), weekly_complete: true )
    	@unfinished_route = @user.customers.where(service_day: Time.now.strftime("%A"), weekly_complete: false )
    	render 'route'
  	end

  	def new_owner
    	@user = User.new
    	@business = Business.find(session[:business_id])
    	render 'new_owner'
  	end

  	def owner_create
     	@user = User.new(user_params)
     	@user.admin = true
     	@user.business_id = session[:business_id]
    	if @user.save
      		session[:user_id] = @user.id
      		redirect_to user_path(@user)
    	else
      		@errors = @user.errors.full_messages
      		render 'new'
    	end
  	end

  	def forgot_password
    	@user = User.new
  	end

  	def request_password
    	@user = User.find_by(email: user_params[:email])
      if @user
    	 UserMailer.reset_password(@user).deliver
      end
  	end

  	def reset_password
    	@user = User.find(params[:id])
  	end

  	def update_password
    	@user = User.find(params[:id])
    	session[:user_id] = @user.id
    	session[:business_id] = @user.business_id
    	@user.update_attributes(user_params)
    	redirect_to action:'show', :id => @user.id
  	end

  	private
  	def user_params
    	params.require(:user).permit(:first_name, :last_name, :email, :password, :admin, :phone, :user_id)
  	end
end
