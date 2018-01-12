class RepairsController < ApplicationController
	def index
    	@open_repairs = Repair.where(complete: false)
    	@finished_repairs = Repair.where(complete: true)
    end

    def new
    	@repair = Repair.new
    end

  	def create
    	@repair = Repair.new(repair_params)
    	@repair.user_id = session[:user_id]
    	if @repair.save
        	RepairMailer.repair_open(@repair).deliver
        	redirect_to repair_path(@repair)
    	else
        	@errors = @repair.errors.full_messages
      		render 'new'
    	end
    end

    def show
    	@repair = Repair.find(params[:id])
    	@image = Image.new
  	end

  	def edit
    	@repair = Repair.find(params[:id])
  	end

  	def update
    	@repair = Repair.find(params[:id])
    	@repair.update_attributes(repair_params)
    	redirect_to action:'show', :id => @repair.id
  	end

  	def complete
    	@repair = Repair.find(params[:id])
    	RepairMailer.repair_complete(@repair).deliver
    	@repair.complete = true
   		@repair.save
    	redirect_back(fallback_location: root_path)
  	end

  	private
  	def repair_params
    	params.require(:repair).permit(:description, :customer_id, :title, :complete)
  	end
end
