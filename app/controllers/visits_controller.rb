class VisitsController < ApplicationController
	def new
    	@visit = Visit.new
  	end

  	def create
    	@visit = Visit.new(visit_params)
    	@visit.user_id = session[:user_id]
    	if @visit.save
      		VisitMailer.visit_complete(@visit).deliver
      		@visit.customer.weekly_complete = true
      		@visit.customer.save
      		redirect_to controller: 'users', action: 'route'
    	else
      		@errors = @user.errors.full_messages
      		redirect_back
    	end
  	end

  	def show
    	@visit = Visit.find(params[:id])
  	end

  	private
  	def visit_params
    	params.require(:visit).permit(:chlorine, :ph, :alkalinity, :stabilizer, :salt, :clean_tile, :leaf_net, :vacuum, :brush, :skimmer_basket, :pump_basket, :clean_filters, :new_filters, :add_chlorine, :add_acid, :add_bicarb, :add_stabilizer, :add_chlorine_tab, :customer_id)
  	end
end
