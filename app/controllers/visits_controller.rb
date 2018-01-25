class VisitsController < ApplicationController
	def new
    @customer = Customer.find_by_id(params[:id])
    @logged_in_user = User.find_by_id(session[:user_id])
    if @customer && @customer.user.id == session[:user_id] || @logged_in_user && @logged_in_user.admin && @customer.business == @logged_in_user.business
    	   @visit = Visit.new
    else
      redirect_to "/"
    end
  end

	def create
    if session[:user_id]
      @customer = Customer.find_by_id(visit_params[:customer_id])
    end
    @logged_in_user = User.find_by_id(session[:user_id])
    if @customer && @customer.user.id == session[:user_id] || @logged_in_user && @logged_in_user.admin && @customer.business == @logged_in_user.business
      @visit = Visit.new(visit_params)
      @visit.user_id = session[:user_id]
      customer = @visit.customer
      if @visit.save
          VisitMailer.visit_complete(@visit).deliver
          customer.weekly_visit_str += Time.now.strftime("%A") + " "
          if customer.days_list.count == customer.days_visited_list.count
            @visit.customer.weekly_complete = true
          end
          @visit.customer.save
          redirect_to controller: 'customers', action: 'show', id: customer.id
      else
          @errors = @user.errors.full_messages
          redirect_to controller: 'customers', action: 'show', id: customer.id
      end
    else
      binding.pry
      redirect_to "/"
    end
	end

  	def show
      @visit = Visit.find_by_id(params[:id])
      if @visit
        @customer = @visit.customer
      end
      @logged_in_user = User.find_by_id(session[:user_id])
        if @customer && @customer.user.business.id == session[:business_id] || @customer && @customer.user.id == session[:user_id] || @logged_in_user && @customer && @logged_in_user.admin && @customer.business == @logged_in_user.business
    	    render "show"
        else
          redirect_to "/"
        end
  	end

  	private
  	def visit_params
    	params.require(:visit).permit(:chlorine, :ph, :alkalinity, :stabilizer, :salt, :clean_tile, :leaf_net, :vacuum, :brush, :skimmer_basket, :pump_basket, :clean_filters, :new_filters, :add_chlorine, :add_acid, :add_bicarb, :add_stabilizer, :add_chlorine_tab, :customer_id)
  	end
end
