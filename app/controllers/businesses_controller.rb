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
        flash[:notice] = "Enter Required Fields(*)"
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
    @note = Note.new
    if @business
      @customers = customer_search(params[:search], @business.customers.order(:last_name))
      @repairs = repairs_search(params[:search], @business.repairs.where(:complete => false).order(:created_at))
      @employees = employees_search(params[:search], @business.users.where(:active_employee => true).order(:last_name))
      # @employees = @business.users.where(:active_employee => true).order(:last_name)
      # @customers = @business.customers.order(:last_name)
      # @repairs = @business.repairs.where(:complete => false).order(:created_at)
    end
  end

  def edit
    @business = Business.find_by_id(params[:id])
    respond_to do |format|
      format.js { render partial: "businesses/ajax_show_form", locals: {business: @business} }
    end
    if logged_in_business?
    else
      root_redirect_path
    end
  end

  def update
    @business = Business.find_by_id(params[:id])
    @business.update_attributes(business_params)
    respond_to do |format|
      format.js { render partial: "businesses/ajax_business_update", locals: {business: @business} }
    end
    # if logged_in_business?
    #     if @business.update_attributes(business_params)
    #       redirect_to @business
    #     else
    #       flash[:notice] = "Enter Required Fields(*)"
    #       redirect_to '/businesses/' + @business.id.to_s + '/edit'
    #     end
    # else
    #   root_redirect_path
    # end
  end

  def reset_weekely_visit
    @business = Business.find_by_id(params[:id])
    @logged_in_user = User.find_by_id(session[:user_id])
    allow_business_and_admin_access
    if @business
      @customers = @business.customers
      @unfinished_pools = select_pools_completed_status(false)
      # BusinessMailer.unfinished_pool_report(@business, @unfinished_pools).deliver
      reset_pools
      flash[:notice] = "Reset Complete"
        redirect_to "/businesses/" + @business.id.to_s
      # respond_to do |format|
      #   format.js { render partial: "successful_visit_reset" }
      # end
    end
  end

  private
    def business_params
      params.require(:business).permit(:owners_first_name, :owners_last_name, :business_name, :email, :phone, :id, :password)
    end
end
