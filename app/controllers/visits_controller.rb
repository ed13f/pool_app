class VisitsController < ApplicationController
  include CustomersHelper
	def new
    @customer = Customer.find_by_id(params[:id])
    @logged_in_user = User.find_by_id(session[:user_id])
    # allow_only_user_and_admin
    @visit = Visit.new
    respond_to do |format|
      format.js { render partial: "visits/ajax_show_form", locals: {visit: @visit, customer: @customer } }
    end
  end

	def create
    # session[:user_id] ? @customer = Customer.find_by_id(visit_params[:customer_id]) : nil
    @customer = Customer.find_by_id(visit_params[:customer_id])
    # @logged_in_user = User.find_by_id(session[:user_id])
    # allow_only_user_and_admin
    @visit = Visit.new(visit_params)
    # @visit.user_id = session[:user_id]
    @visit.user_id = @customer.user.id
    customer = @visit.customer
    if @visit.save
        # customer.receive_emails ? VisitMailer.visit_complete(@visit).deliver : nil
        # end
        # customer.weekly_visit_str += Time.now.strftime("%A") + " "
        if customer.days_list.count == customer.days_visited_list.count
          @visit.customer.weekly_complete = true
        end
        @visit.customer.save
        respond_to do |format|
          format.js { render partial: "visits/ajax_create_form", locals: {visit: @visit, customer: @customer } }
        end
    else
        flash[:notice] = "Enter Required Feilds(*)"
        respond_to do |format|
          format.js { render partial: "visits/ajax_create_form", locals: {visit: @visit, customer: @customer } }
        end
    end
	end

  	def show
      @visit = Visit.find_by_id(params[:id])
      @visit ? @customer = @visit.customer : nil
      @logged_in_user = User.find_by_id(session[:user_id])
        customer_allow_user_business_or_admin
  	end

  	private
  	def visit_params
    	params.require(:visit).permit(:chlorine, :ph, :alkalinity, :stabilizer, :salt, :clean_tile, :leaf_net, :vacuum, :brush, :skimmer_basket, :pump_basket, :clean_filters, :new_filters, :add_chlorine, :add_acid, :add_bicarb, :add_stabilizer, :add_chlorine_tab, :customer_id)
  	end
end
