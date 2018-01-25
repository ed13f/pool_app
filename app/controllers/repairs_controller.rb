class RepairsController < ApplicationController
  include ApplicationHelper
	def index
    @session = User.find_by_id(session[:user_id])
    if @session && @session.admin
      @open_repairs = @session.repairs.where(complete: false)
      @finished_repairs = @session.repairs.where(complete: true)
    elsif session[:business_id]
      @session = Business.find_by_id(session[:business_id])
      @open_repairs = @session.repairs.where(complete: false)
      @finished_repairs = @session.repairs.where(complete: true)
    else
      redirect_to "/"
    end
  end

    def new
      @customer = Customer.find_by_id(params[:id])
      @logged_in_user = User.find_by_id(session[:user_id])
      if @customer && @logged_in_user && @customer.business == @logged_in_user.business && @logged_in_user.admin || @customer && @customer.user.business.id == session[:business_id] || @customer.user.id == session[:user_id]
    	@repair = Repair.new
      else
        redirect_to "/"
      end
    end

  	def create
      @customer = Customer.find_by_id(repair_params[:customer_id])
      @logged_in_user = User.find_by_id(session[:user_id])
      if @customer && @logged_in_user && @customer.business == @logged_in_user.business && @logged_in_user.admin || @customer && @customer.user.business.id == session[:business_id] || @customer.user.id == session[:user_id]
      	@repair = Repair.new(repair_params)
        if session[:user_id]
      	@repair.user_id = session[:user_id]
        end
      	if @repair.save
          RepairMailer.repair_open(@repair).deliver
          redirect_to repair_path(@repair)
      	else
          @errors = @repair.errors.full_messages
        	render 'new'
      	end
      else
        redirect_to "/"
      end
    end

    def show
      @repair = Repair.find_by_id(params[:id])
      if @repair
        @customer = @repair.customer
      end
      @logged_in_user = User.find_by_id(session[:user_id])
      if @customer && @logged_in_user && @customer.business == @logged_in_user.business && @logged_in_user.admin || @customer && @customer.user.business.id == session[:business_id] || @customer && @customer.user.id == session[:user_id]
          @image = Image.new
          render "show"
      else
          redirect_to "/"
      end
  	end

  	def edit
      @repair = Repair.find_by_id(params[:id])
      if @repair
        @customer = @repair.customer
      end
      @logged_in_user = User.find_by_id(session[:user_id])
      if @customer && @logged_in_user && @customer.business == @logged_in_user.business && @logged_in_user.admin || @customer && @customer.user.business.id == session[:business_id] || @customer && @customer.user.id == session[:user_id]
          @image = Image.new
          render "edit"
      else
        redirect_to "/"
      end
  	end

  	def update
      @repair = Repair.find_by_id(params[:id])
      if @repair
        @customer = @repair.customer
      end
      @logged_in_user = User.find_by_id(session[:user_id])
      if @customer && @logged_in_user && @customer.business == @logged_in_user.business && @logged_in_user.admin || @customer && @customer.user.business.id == session[:business_id] || @customer && @customer.user.id == session[:user_id]
        @repair.update_attributes(repair_params)
        redirect_to @repair
      else
        redirect_to "/"
      end
  	end

  	def complete
      @repair = Repair.find_by_id(params[:id])
      if @repair
        @customer = @repair.customer
      end
      @logged_in_user = User.find_by_id(session[:user_id])
      if @customer && @logged_in_user && @customer.business == @logged_in_user.business && @logged_in_user.admin || @customer && @customer.user.business.id == session[:business_id] || @customer && @customer.user.id == session[:user_id]
        RepairMailer.repair_complete(@repair).deliver
        @repair.complete = true
        @repair.save
        redirect_back(fallback_location: root_path)
      else
          redirect_to "/"
      end
  	end

  	private
  	def repair_params
    	params.require(:repair).permit(:description, :customer_id, :title, :complete)
  	end
end
