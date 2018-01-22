class RepairsController < ApplicationController
  include ApplicationHelper
	def index
    if session[:user_id]
      @session = User.find_by_id(session[:user_id])
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
      require_logged_in_user
      @customer = Customer.find_by_id(params[:id])
      if @customer
        if @customer.id == session[:user_id] || @customer.user.business.id == session[:business_id]
      	@repair = Repair.new
        else
          redirect_to "/"
        end
      end
    end

  	def create
      require_logged_in_user
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
    end

    def show
    	@repair = Repair.find_by_id(params[:id])
      if @repair
        @business = @repair.customer.user.business
        if @business.id == session[:business_id] || @business.users.find_by_id(session[:user_id])
          @image = Image.new
          render "show"
        else
          redirect_to "/"
        end
      else
        redirect_to "/"
      end
  	end

  	def edit
    	@repair = Repair.find_by_id(params[:id])
      if @repair
        @business = @repair.customer.user.business
        if @business.id == session[:business_id] || @business.users.find_by_id(session[:user_id])
          @image = Image.new
          render "edit"
        else
          redirect_to "/"
        end
      else
        redirect_to "/"
      end
  	end

  	def update
    	@repair = Repair.find_by_id(params[:id])
      if @repair
        @business = @repair.customer.user.business
        if @business.id == session[:business_id] || @business.users.find_by_id(session[:user_id])
    	     @repair.update_attributes(repair_params)
           redirect_to action:'show', :id => @repair.id
        else
          redirect_to "/"
        end
      else
        redirect_to "/"
      end
  	end

  	def complete
    	@repair = Repair.find_by_id(params[:id])
      if @repair
        @business = @repair.customer.user.business
        if @business.id == session[:business_id] || @business.users.find_by_id(session[:user_id])
  	      RepairMailer.repair_complete(@repair).deliver
  	      @repair.complete = true
 		      @repair.save
          redirect_back(fallback_location: root_path)
        else
          redirect_to "/"
        end
      else
        redirect_to "/"
      end
  	end

  	private
  	def repair_params
    	params.require(:repair).permit(:description, :customer_id, :title, :complete)
  	end
end
