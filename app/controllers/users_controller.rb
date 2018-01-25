class UsersController < ApplicationController
  	def new
      @user = User.find_by_id(session[:user_id])
      if session[:business_id] || @user && @user.admin
    	  @user = User.new
        render "new"
      else
        redirect_to "/"
      end
  	end

  	def create
      @logged_in_user = User.find_by_id(session[:user_id])
      if session[:business_id] || @logged_in_user && @logged_in_user.admin
    	  @user = User.new(user_params)
        if session[:business_id]
    	    @user.business_id = session[:business_id]
        elsif session[:user_id]
          @user.business_id = @logged_in_user.business.id
        end
    	  if @user.save
      		UserMailer.welcome_email(@user).deliver
      		redirect_to user_path(@user)
    	  else
      		@errors = @user.errors.full_messages
      		render 'new'
    	  end
      else
        redirect_to "/"
      end
  	end

  	def show
    	@user = User.find_by_id(params[:id])
      @logged_in_user = User.find_by_id(session[:user_id])
      if @user && session[:business_id] == @user.business.id || @user && @user.id == session[:user_id] || @user && @logged_in_user.admin && @logged_in_user.business == @user.business
        @pools = @user.customers
        @finished_route = @user.customers.select do |customer|
          customer.days_list.include?(Time.now.strftime("%A")) && customer.days_visited_list.include?(Time.now.strftime("%A"))
        end
        @unfinished_route = @user.customers.select do |customer|
          customer.days_list.include?(Time.now.strftime("%A")) && customer.weekly_complete == false && !customer.days_visited_list.include?(Time.now.strftime("%A"))
        end
        @hash = Gmaps4rails.build_markers(@pools) do |customer, marker|
          marker.lat customer.latitude
          marker.lng customer.longitude
          marker.infowindow render_to_string(:partial => "/customers/map_customer_info.html.erb", :locals => { :object => customer})
        end
        render "show"
      else
        redirect_to "/"
      end
    end

  	def edit
    	@user = User.find_by_id(params[:id])
      @logged_in_user = User.find_by_id(session[:user_id])
      if @user && @user.business.id == session[:business_id] || @user && @user.id == session[:user_id] || @user && @logged_in_user.admin && @logged_in_user.business == @user.business
        render "edit"
      else
        redirect_to "/"
      end
  	end

  	def update
      @user = User.find_by_id(params[:id])
      @logged_in_user = User.find_by_id(session[:user_id])
      if @user && @user.business.id == session[:business_id] || @user && @user.id == session[:user_id] || @user && @logged_in_user.admin && @logged_in_user.business == @user.business
    	  @user.update_attributes(user_params)
    	  redirect_to action:'show', :id => @user.id
      else
        redirect_to "/"
      end
  	end

  	# def route
   #  	@user = User.find(session[:user_id])
   #  	# binding.pry
   #  	@finished_route = @user.customers.where(service_day: Time.now.strftime("%A"), weekly_complete: true )
   #  	@unfinished_route = @user.customers.where(service_day: Time.now.strftime("%A"), weekly_complete: false )
   #  	render 'route'
  	# end

  	# def new_owner
   #  	@user = User.new
   #  	@business = Business.find(session[:business_id])
   #  	render 'new_owner'
  	# end

  	# def owner_create
   #   	@user = User.new(user_params)
   #   	@user.admin = true
   #   	@user.business_id = session[:business_id]
   #  	if @user.save
   #    		session[:user_id] = @user.id
   #    		redirect_to user_path(@user)
   #  	else
   #    		@errors = @user.errors.full_messages
   #    		render 'new'
   #  	end
  	# end

  	# def forgot_password
   #  	@user = User.new
  	# end

  	# def request_password
   #  	@user = User.find_by(email: user_params[:email])
   #      @reset = Reset.new
   #      @reset.email = user_params[:email]
   #      @reset.temp_pass = rand_password=('a'..'z').to_a.shuffle.first(8).join
   #      @reset.user_id = @user.id
   #      @reset.save
   #    if @user
   #  	 UserMailer.reset_password(@user, @reset).deliver
   #    end
  	# end

  	# def reset_password
   #  	@user = User.find_by_id(params[:id])
   #    @reset = Reset.new
   #    # @reset = Reset.find_by(email: @user.email)
  	# end

  	# def update_password
   #  	@user = User.find(params[:id])
   #  	session[:user_id] = @user.id
   #  	session[:business_id] = @user.business_id
   #  	@user.update_attributes(user_params)
   #  	redirect_to action:'show', :id => @user.id
  	# end

  	private
  	def user_params
    	params.require(:user).permit(:first_name, :last_name, :email, :password, :admin, :phone, :user_id)
  	end
end
