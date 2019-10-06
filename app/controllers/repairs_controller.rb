class RepairsController < ApplicationController
  include ApplicationHelper
  include RepairsHelper
  include CustomersHelper

	def index
    @session = User.find_by_id(session[:user_id])
    if @session && @session.admin
      @session.business.repairs
      @open_repairs = pool_completion_select(false)
      @finished_repairs = pool_completion_select(true)
    elsif session[:business_id]
      @session = Business.find_by_id(session[:business_id])
      @repairs = @session.repairs
      @open_repairs = pool_completion_select(false)
      @finished_repairs = pool_completion_select(true)
    else
      root_redirect_path
    end
  end

  def new
    @customer = Customer.find_by_id(params[:id])
    @logged_in_user = User.find_by_id(session[:user_id])
    customer_allow_user_business_or_admin
    @repair = Repair.new
  	respond_to do |format|
      format.js { render partial: "repairs/ajax_show_form", locals: {repair: @repair, customer: @customer} }
    end
  end

	def create
    @customer = Customer.find_by_id(repair_params[:customer_id])
    @logged_in_user = User.find_by_id(session[:user_id])
    customer_allow_user_business_or_admin
  	@repair = Repair.new(repair_params)
    if session[:user_id]
  	@repair.user_id = session[:user_id]
    end
  	if @repair.save
      # RepairMailer.repair_open(@repair).deliver
      respond_to do |format|
        format.js { render partial: "repairs/ajax_repair_create", locals: {repair: @repair, customer: @customer} }
      end
  	else
      # binding.pry
      @errors = @repair.errors.messages.keys
      @errors = {repair: @errors}
      respond_to do |format|
        format.js { render partial: "application/ajax_error_handling", locals: {errors: @errors} }
      end
  	end
    
  end

  def show
    @repair = Repair.find_by_id(params[:id])
    @customer = find_repairs_customer
    @logged_in_user = User.find_by_id(session[:user_id])
    customer_allow_user_business_or_admin
    @image = Image.new
	end

	def edit
    @repair = Repair.find_by_id(params[:id])
    @customer = find_repairs_customer
    @logged_in_user = User.find_by_id(session[:user_id])
    customer_allow_user_business_or_admin
    @image = Image.new
    respond_to do |format|
      format.js { render partial: "repairs/ajax_show_form", locals: {repair: @repair, customer: @customer} }
    end
	end

	def update
    @repair = Repair.find_by_id(params[:id])
    @customer = find_repairs_customer
    @logged_in_user = User.find_by_id(session[:user_id])
    customer_allow_user_business_or_admin
      if @repair.update_attributes(repair_params)
        respond_to do |format|
          format.js { render partial: "repairs/ajax_repair_update", locals: {repair: @repair, customer: @customer} }
        end
      else
        @errors = @repair.errors.messages.keys
        @errors = {repair: @errors}
        respond_to do |format|
          format.js { render partial: "application/ajax_error_handling", locals: {errors: @errors} }
        end
      end
	end

	def complete
    @repair = Repair.find_by_id(params[:id])
    @customer = find_repairs_customer
    @logged_in_user = User.find_by_id(session[:user_id])
    customer_allow_user_business_or_admin
      # RepairMailer.repair_complete(@repair).deliver
      @repair.complete = true
      @repair.save
      respond_to do |format|
        format.js { render partial: "complete_repair", locals: {repair: @repair} }
      end
	end

  def destroy
    @repair = Repair.find_by_id(params[:id])
    @logged_in_user = User.find_by_id(session[:user_id])
    customer_allow_user_business_or_admin
    @repair.destroy
    # redirect_to "/"
  end

	private
	def repair_params
  	params.require(:repair).permit(:description, :customer_id, :title, :complete)
	end
end
