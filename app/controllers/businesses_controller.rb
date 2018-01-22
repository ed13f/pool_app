class BusinessesController < ApplicationController
  def new
    @business = Business.new
    @user = User.new
  end

  def create
    @business = Business.new(business_params)
    if @business.save
      session[:business_id] = @business.id
      @user = User.new
      redirect_to business_path(@business)
    else
      @errors = @business.errors.full_messages
      render 'new'
    end
  end

  def show
    @business = Business.find_by_id(params[:id])
    if @business && @business.id == session[:business_id]
      @employees = @business.users
      @customers = @business.customers
      @repairs = @business.repairs
      render 'show'
    else
      puts "YESSSSSSSSSSSSSSSS"
      redirect_to '/businesses/new'
    end
  end

  def edit
    @business = Business.find_by_id(params[:id])
    if @business && @business.id == session[:business_id]
      render 'edit'
    else
      if session[:business_id]
        redirect_to :controller => 'businesses', :action => 'show', :id => session[:business_id]
      elsif session[:business_id]
        redirect_to :controller => 'users', :action => 'show', :id => session[:users_id]
      else
        redirect_to '/'
      end
    end
  end

  def update
    @business = Business.find_by_id(params[:id])
    if @business && @business.id == session[:business_id]
        @business.update_attributes(business_params)
        redirect_to @business
    else
      if session[:business_id]
        redirect_to :controller => 'businesses', :action => 'show', :id => session[:business_id]
      elsif session[:business_id]
        redirect_to :controller => 'users', :action => 'show', :id => session[:users_id]
      else
        redirect_to '/'
      end
    end
  end

  def reset_weekely_visit
    @business = Business.find_by_id(params[:id])
    if @business && @business.id == session[:business_id]
      @customers = @business.customers
      @unfinished_pools = @customers.select{ |customer| customer.weekly_complete == false }
      BusinessMailer.unfinished_pool_report(@business, @unfinished_pools).deliver
      @customers.map do |customer|
        customer.weekly_complete = false
        customer.weekly_visit_str = ""
        customer.save
      end
      redirect_to action: 'show', :id => @business.id
    else
      if session[:business_id]
        redirect_to :controller => 'businesses', :action => 'show', :id => session[:business_id]
      elsif session[:business_id]
        redirect_to :controller => 'users', :action => 'show', :id => session[:users_id]
      else
        redirect_to '/'
      end
    end

  end

  private
    def business_params
      params.require(:business).permit(:owners_first_name, :owners_last_name, :business_name, :email, :phone, :id, :password)
    end
end
