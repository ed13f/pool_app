class BusinessesController < ApplicationController
  include BusinessesHelper
  include ApplicationHelper


  def new
    if !session[:user_id] && !session[:business_id]
      @business = Business.new
      @user = User.new
    else
      root_redirect_path
    end
  end

  def create
    if !session[:user_id] && !session[:business_id]
      @business = Business.new(business_params)
      if @business.save
        session[:business_id] = @business.id
        redirect_to business_path(@business)
      else
        flash[:notice] = @business.errors.full_messages
        redirect_to '/businesses/new'
      end
    else
      root_redirect_path
    end
  end

  def show
    @business = Business.find_by_id(params[:id])
    @logged_in_user = User.find_by_id(session[:user_id])
    allow_business_and_admin_access
    if @business
      @employees = @business.users.where(:active_employee => true).order(:last_name)
      @customers = @business.customers.order(:last_name)
      @repairs = @business.repairs.where(:complete => false).order(:created_at)
    end
  end

  def edit
    @business = Business.find_by_id(params[:id])
    if logged_in_business?
    else
      root_redirect_path
    end
  end

  def update
    @business = Business.find_by_id(params[:id])
    if logged_in_business?
        if @business.update_attributes(business_params)
          redirect_to @business
        else
          flash[:notice] = @business.errors.full_messages
          redirect_to '/businesses/' + @business.id.to_s + '/edit'
        end
    else
      root_redirect_path
    end
  end

  def reset_weekely_visit
    @business = Business.find_by_id(params[:id])
    @logged_in_user = User.find_by_id(session[:user_id])
    allow_business_and_admin_access
    if @business
      @customers = @business.customers
      @unfinished_pools = select_pools_completed_status(false)
      BusinessMailer.unfinished_pool_report(@business, @unfinished_pools).deliver
      reset_pools
      respond_to do |format|
        format.js
      end
    end
  end

  private
    def business_params
      params.require(:business).permit(:owners_first_name, :owners_last_name, :business_name, :email, :phone, :id, :password)
    end
end
