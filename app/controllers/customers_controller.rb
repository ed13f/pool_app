class CustomersController < ApplicationController
  # @customer.days.build
  # require_logged_in_user
  include ApplicationHelper
	def new
    @customer = Customer.new
    if session[:business_id] || session[:user_id]
      if session[:user_id]
        @logged_in_user = User.find_by_id(session[:user_id])
          if @logged_in_user.admin
            @employees = @logged_in_user.business.users
            @user_admin = @logged_in_user.admin
          end
      elsif session[:business_id]
        @employees = Business.find_by_id(session[:business_id]).users
      end
    else
      redirect_to "/"
    end
  end

  def create
    if session[:business_id] || session[:user_id]
      @customer = Customer.new(customer_params)
      if customer_params[:user_id] == "" || customer_params[:user_id] == nil
      	@customer.user_id = session[:user_id]
      end
      if @customer.save
        CustomerMailer.new_customer(@customer).deliver
        redirect_to customer_path(@customer)
      else
        @errors = @customer.errors.full_messages
        redirect_to 'customers/new'
      end
    else
      redirect_to "/"
    end
  end

  def show
    @customer = Customer.find_by_id(params[:id])
    @logged_in_user = User.find_by_id(session[:user_id])
    if @customer && @customer.user.business.id == session[:business_id] || @customer && @customer.user.id == session[:user_id] || @customer && @logged_in_user && @logged_in_user.admin && @logged_in_user.business == @customer.business
      @notes = @customer.notes
      @note = Note.new
      render 'show'
    elsif session[:business_id] || session[:user_id]
      redirect_to "/"
    else
      redirect_to "/"
    end
  end

  def edit
    @customer = Customer.find_by_id(params[:id])
    @logged_in_user = User.find_by_id(session[:user_id])
    if @customer && @customer.user.business.id == session[:business_id] || @customer && @customer.user.id == session[:user_id] || @customer && @logged_in_user && @logged_in_user.admin && @logged_in_user.business == @customer.business
      if session[:user_id]
        @logged_in_user = User.find_by_id(session[:user_id])
        if @logged_in_user.admin
          @employees = @logged_in_user.business.users
          @user_admin = @logged_in_user.admin
        end
      elsif session[:business_id]
        @employees = Business.find_by_id(session[:business_id]).users
      end
    elsif session[:business_id] || session[:user_id]
      redirect_to "/"
    else
      redirect_to "/"
    end
  end

  def update
    @customer = Customer.find_by_id(params[:id])
    @logged_in_user = User.find_by_id(session[:user_id])
    if @customer && @customer.user.business.id == session[:business_id] || @customer && @customer.user.id == session[:user_id] || @customer && @logged_in_user && @logged_in_user.admin && @logged_in_user.business == @customer.business
      if customer_params[:user_id] == "" || customer_params[:user_id] == nil
        @customer.user_id = session[:user_id]
      end
      @customer.update_attributes(customer_params)
      redirect_to action:'show', :id => @customer.id
    elsif session[:business_id] || session[:user_id]
      redirect_to "/"
    else
      redirect_to "/"
    end
  end

  def history
    @customer = Customer.find_by_id(params[:id])
    @logged_in_user = User.find_by_id(session[:user_id])
    if @customer && @customer.user.business.id == session[:business_id] || @customer && @customer.user.id == session[:user_id] || @customer && @logged_in_user && @logged_in_user.admin && @logged_in_user.business == @customer.business
      @visit_history = @customer.visits
      @repair_history = @customer.repairs
    elsif session[:business_id] || session[:user_id]
      redirect_to "/"
    else
      redirect_to "/"
    end



    # @customer = Customer.find_by_id(params[:id])
    # if @customer
    #   if @customer.user.business.id == session[:business_id] || @customer.user.id == session[:user_id]
    #     @customer = Customer.find(params[:id])
    #     @visit_history = @customer.visits
    #     @repair_history = @customer.repairs
    #   elsif session[:business_id] || session[:user_id]
    #     redirect_to "/"
    #   end
    # elsif session[:business_id] || session[:user_id]
    #   redirect_to "/"
    # end
  end

  # def directions
  #   @customer = Customer.find(params[:id])
  #   @customer
  # end

  private
  def customer_params
    params.require(:customer).permit(:first_name, :last_name,:phone, :email, :street_address, :city, :state, :zip_code, :gate_code, :filter_type, :pump_type, :receive_emails, :visit_per_week, :user_id, :monday, :tuesday, :wednesday, :thursday, :friday)
  end
end
