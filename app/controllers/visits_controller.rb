class VisitsController < ApplicationController
  include CustomersHelper
	def new
    @customer = Customer.find_by_id(params[:id])
    @logged_in_user = User.find_by_id(session[:user_id])
    allow_only_user_and_admin
    	   @visit = Visit.new
  end

	def create
    session[:user_id] ? @customer = Customer.find_by_id(visit_params[:customer_id]) : nil
    @logged_in_user = User.find_by_id(session[:user_id])
    allow_only_user_and_admin
    @visit = Visit.new(visit_params)
    @visit.user_id = session[:user_id]
    customer = @visit.customer
    if @visit.save
        customer.receive_emails ? VisitMailer.visit_complete(@visit).deliver : nil
        # end
        customer.weekly_visit_str += Time.now.strftime("%A") + " "
        if customer.days_list.count == customer.days_visited_list.count
          @visit.customer.weekly_complete = true
        end
        @visit.customer.save
        redirect_to @customer
    else
        flash[:notice] = @visit.errors.full_messages
        redirect_to "/customers/visits/" + @customer.id.to_s
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
