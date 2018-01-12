class ImagesController < ApplicationController
	def new
    	@image = Image.new
  	end

  	def create
    	@image = Image.new( image_params )
    	if @image.save
      	redirect_back(fallback_location: root_path)
    	else
      		render new
    	end
  	end

  	private
  	def image_params
    	params.require(:image).permit(:photo, :repair_id)
  	end
end
