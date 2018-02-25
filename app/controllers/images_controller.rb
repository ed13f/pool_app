class ImagesController < ApplicationController
	def new
    	@image = Image.new
  	end

  	def create
    	@image = Image.new( image_params )
      repair = Repair.find_by_id(image_params[:repair_id])
    	if @image.save
      	redirect_back(fallback_location: root_path)
    	else
        flash[:notice] = "Upload Image"
      	redirect_to "/repairs/" + repair.id.to_s
    	end
  	end

  	private
  	def image_params
    	params.require(:image).permit(:photo, :repair_id)
  	end
end
