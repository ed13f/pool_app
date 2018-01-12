class DaysController < ApplicationController
	def	create
		@day = Day.new(day_params)
		if @day.save
			redirect_back fallback_location: "http://localhost:3000/"
		end	

	end

	private
	def day_params
	    params.require(:day).permit(:monday, :tuesday, :wednesday, :thursday, :friday)
	end
end
