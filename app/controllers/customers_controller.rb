class CustomersController < ApplicationController
	def new
    @customer = Customer.new
    @customer.days.build
    @employees = User.find(session[:user_id]).business.users
  end

  def create
    @customer = Customer.new(customer_params)
    # @days = Day.new(customer_params[:days_attributes]["0"])
    # @days.save
    if customer_params[:user_id] = ""
    	@customer.user_id = session[:user_id]
    end
    if @customer.save
      redirect_to customer_path(@customer)
      CustomerMailer.new_customer(@customer).deliver
    else
      @employees = User.find(session[:user_id]).business.users
      @errors = @customer.errors.full_messages
      render 'new'
    end
  end

  def show
    @customer = Customer.find(params[:id])
    @notes = @customer.notes
    @note = Note.new
    render 'show'
  end

  def edit
    @customer = Customer.find(params[:id])
    @customer.days.build
    @employees = User.find(session[:user_id]).business.users
  end

  def update
    @customer = Customer.find(params[:id])
    @customer.update_attributes(customer_params)
    redirect_to action:'show', :id => @customer.id
  end

  def history
    @customer = Customer.find(params[:id])
    @visit_history = @customer.visits
    @repair_history = @customer.repairs
  end

  def directions
    @customer = Customer.find(params[:id])
    @customer
  end

  private
  def customer_params
    params.require(:customer).permit(:first_name, :last_name,:phone, :email, :street_address, :city, :state, :zip_code, :gate_code, :service_day, :filter_type, :pump_type, :spa, :visit_per_week, :user_id, :monday, :tuesday, :wednesday, :thursday, :friday)
  end
end
