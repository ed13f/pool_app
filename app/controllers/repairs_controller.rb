class RepairsController < ApplicationController
  include ApplicationHelper
  include RepairsHelper
  include CustomersHelper
	def index
    @session = User.find_by_id(session[:user_id])
    if @session && @session.admin
      @open_repairs = pool_completion_select(false)
      @finished_repairs = pool_completion_select(true)
    elsif session[:business_id]
      @session = Business.find_by_id(session[:business_id])
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
          RepairMailer.repair_open(@repair).deliver
          redirect_to repair_path(@repair)
      	else
          flash[:notice] = "Enter Required Fields(*)"
          redirect_to "/customers/" + repair_params[:customer_id].to_s + "/repairs"
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
  	end

  	def update
      @repair = Repair.find_by_id(params[:id])
      @customer = find_repairs_customer
      @logged_in_user = User.find_by_id(session[:user_id])
      customer_allow_user_business_or_admin
        if @repair.update_attributes(repair_params)
          redirect_to @repair
        else
          flash[:notice] = "Enter Required Fields(*)"
          redirect_to "/repairs/" + @repair.id.to_s + "/edit"
        end
  	end

  	def complete
      @repair = Repair.find_by_id(params[:id])
      @customer = find_repairs_customer
      @logged_in_user = User.find_by_id(session[:user_id])
      customer_allow_user_business_or_admin
        RepairMailer.repair_complete(@repair).deliver
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
