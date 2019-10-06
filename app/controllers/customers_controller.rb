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
    respond_to do |format|
      format.js { render partial: "customers/ajax_customer_show_form", locals: {customer: @customer} }
    end
  end

  def create
      user_or_business_logged_in
      @customer = Customer.new(customer_params)
      @customer.user_id = assign_user_id
      @customer.phone = customer_params[:phone].gsub(/[^\d]/, '')
      if @customer.days_list.length != 0 && @customer.save
        # CustomerMailer.new_customer(@customer).deliver
        respond_to do |format|
          format.js { render partial: "customers/ajax_customer_create_form", locals: {customer: @customer} }
        end
      else
        # flash[:notice] = "Enter Required Fields(*)"
        @customer.valid?
        @errors = @customer.errors.messages.keys
        @customer.days_list.length == 0 ? @errors.push(:days) : nil
        @errors = {customer: @errors}
        respond_to do |format|
          format.js { render partial: "application/ajax_error_handling", locals: {errors: @errors} }
        end
      end
  end
  
  def show
    @customer = Customer.find_by_id(params[:id])
    @logged_in_user = User.find_by_id(session[:user_id])
    @pools = Customer.all
    customer_allow_user_business_or_admin
    @repairs = @customer.repairs
    if @customer
      @visit_history = @customer.visits.order(created_at: :desc)
      @notes = @customer.notes
      @note = Note.new
    end
  end

  def edit
    @customer = Customer.find_by_id(params[:id])
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
    respond_to do |format|
      format.js { render partial: "customers/ajax_customer_show_form", locals: {customer: @customer} }
    end
  end
  def update
    @customer = Customer.find_by_id(params[:id])
    @logged_in_user = User.find_by_id(session[:user_id])
    customer_allow_user_business_or_admin
    args = customer_params
    args[:phone] = customer_params[:phone].gsub(/[^\d]/, '')
    @customer.update_attributes(args)
    # args[:user_id] = @customer.user_id
    if @customer.days_list.length != 0 && @customer.save
      respond_to do |format|
        format.js { render partial: "customers/ajax_customer_update_form", locals: {customer: @customer} }
      end
    else
      @customer.valid?
      @errors = @customer.errors.messages.keys
      @customer.days_list.length == 0 ? @errors.push(:days) : nil
      @errors = {customer: @errors}
      respond_to do |format|
        format.js { render partial: "application/ajax_error_handling", locals: {errors: @errors} }
      end
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
    respond_to do |format|
      format.js { render partial: "customers/ajax_customer_delete", locals: {customer: @customer} }
    end
  end

  private
  def customer_params
    params.require(:customer).permit(:first_name, :last_name,:phone, :email, :street_address, :city, :state, :zip_code, :gate_code, :filter_type, :pump_type, :receive_emails, :visit_per_week, :user_id, :monday, :tuesday, :wednesday, :thursday, :friday)
  end
end
