class CustomersController < ApplicationController
  include ApplicationHelper
	def new
    @customer = Customer.new
    require_logged_in_user
    @customer.days.build
    if session[:business_id]
      @employees = Business.find_by_id(session[:business_id]).users
    end
  end

  def create
    require_logged_in_user
    @customer = Customer.new(customer_params)
    if customer_params[:user_id] = ""
    	@customer.user_id = session[:user_id]
    end
    if @customer.save
      CustomerMailer.new_customer(@customer).deliver
      redirect_to customer_path(@customer)
    else
      @errors = @customer.errors.full_messages
      redirect_to 'new'
    end
  end

  def show
    require_logged_in_user
    @customer = Customer.find_by_id(params[:id])
    if @customer
      if @customer.user.business.id == session[:business_id] || @customer.user.id == session[:user_id]
        @notes = @customer.notes
        @note = Note.new
        render 'show'
      elsif session[:business_id] || session[:user_id]
        redirect_to "/"
      end
    elsif session[:business_id] || session[:user_id]
      redirect_to "/"
    end
  end

  def edit
    require_logged_in_user
    @customer = Customer.find_by_id(params[:id])
    if @customer
      if @customer.user.business.id == session[:business_id] || @customer.user.id == session[:user_id]
        @customer.days.build
        @employees = @customer.user.business.users
      elsif session[:business_id] || session[:user_id]
      redirect_to "/"
      end
    elsif session[:business_id] || session[:user_id]
      redirect_to "/"
    end
  end

  def update
    require_logged_in_user
    @customer = Customer.find_by_id(params[:id])
    if @customer
      if @customer.user.business.id == session[:business_id] || @customer.user.id == session[:user_id]
        @customer.update_attributes(customer_params)
        redirect_to action:'show', :id => @customer.id
      elsif session[:business_id] || session[:user_id]
        redirect_to "/"
      end
    elsif session[:business_id] || session[:user_id]
      redirect_to "/"
    end
  end

  def history
    require_logged_in_user
    @customer = Customer.find_by_id(params[:id])
    if @customer
      if @customer.user.business.id == session[:business_id] || @customer.user.id == session[:user_id]
        @customer = Customer.find(params[:id])
        @visit_history = @customer.visits
        @repair_history = @customer.repairs
      elsif session[:business_id] || session[:user_id]
        redirect_to "/"
      end
    elsif session[:business_id] || session[:user_id]
      redirect_to "/"
    end
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
