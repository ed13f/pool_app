class CustomersController < ApplicationController
  include ApplicationHelper
  include CustomersHelper
	def new
    @customer = Customer.new
    user_or_business_logged_in
      if session[:user_id]
        @logged_in_user = User.find_by_id(session[:user_id])
          if @logged_in_user.admin
            @employees = @logged_in_user.business.users.order(:last_name)
            @user_admin = @logged_in_user.admin
          end
      elsif session[:business_id]
        @employees = Business.find_by_id(session[:business_id]).users.order(:last_name)
      end
  end

  def create
      user_or_business_logged_in
      @customer = Customer.new(customer_params)
      @customer.user_id = assign_user_id
      @customer.phone = customer_params[:phone].gsub(/[^\d]/, '')
      binding.pry
      if @customer.save

        CustomerMailer.new_customer(@customer).deliver
        redirect_to customer_path(@customer)
      else
        flash[:notice] = "Enter Required Fields(*)"
        redirect_to '/customers/new'
      end
  end

  def show
    @customer = Customer.find_by_id(params[:id])
    @logged_in_user = User.find_by_id(session[:user_id])
    customer_allow_user_business_or_admin
    if @customer
      @notes = @customer.notes
      @note = Note.new
    end
  end

  def edit
    @customer = Customer.find_by_id(params[:id])
    @logged_in_user = User.find_by_id(session[:user_id])
    customer_allow_user_business_or_admin
      if session[:user_id]
        @logged_in_user = User.find_by_id(session[:user_id])
        if @logged_in_user.admin
          @employees = @logged_in_user.business.users
          @user_admin = @logged_in_user.admin
        end
      elsif session[:business_id]
        @employees = Business.find_by_id(session[:business_id]).users
      end
  end

  def update
    @customer = Customer.find_by_id(params[:id])
    @logged_in_user = User.find_by_id(session[:user_id])
    customer_allow_user_business_or_admin
    args = customer_params
    args[:user_id] = assign_user_id
    args[:phone] = customer_params[:phone].gsub(/[^\d]/, '')
      if @customer.update_attributes(args)
        redirect_to action:'show', :id => @customer.id
      else
        flash[:notice] = "Enter Required Fields(*)"
        redirect_to '/customers/' + @customer.id.to_s + "/edit"
      end
  end

  def history
    @customer = Customer.find_by_id(params[:id])
    @logged_in_user = User.find_by_id(session[:user_id])
    customer_allow_user_business_or_admin
    if @customer
      @visit_history = @customer.visits
      @repair_history = @customer.repairs
    end
  end

  def destroy
    @customer = Customer.find_by_id(params[:id])
    @logged_in_user = User.find_by_id(session[:user_id])
    customer_allow_user_business_or_admin
    @customer.destroy
    redirect_to "/"
  end

  private
  def customer_params
    params.require(:customer).permit(:first_name, :last_name,:phone, :email, :street_address, :city, :state, :zip_code, :gate_code, :filter_type, :pump_type, :receive_emails, :visit_per_week, :user_id, :monday, :tuesday, :wednesday, :thursday, :friday)
  end
end
