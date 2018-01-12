class NotesController < ApplicationController
	def new
	    @note = Note.new
	end

    def create
	    @note = Note.new(note_params)
	    	# binding.pry
	    if @note.save
	    	redirect_back(fallback_location: root_path)
	    else
	    	@errors = @note.errors.full_messages
	    	render 'new'
	    end
    end

    def destroy
	  	@note = Note.find(params[:id])
	  	@note.destroy
	  	redirect_back(fallback_location: root_path)
	end
	
    private
    def note_params
    	params.require(:note).permit(:description, :customer_id)
    end
end
