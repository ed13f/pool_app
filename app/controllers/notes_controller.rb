class NotesController < ApplicationController
	# def new
	#     @note = Note.new
	# end

    def create
      @customer = Customer.find_by_id(note_params[:customer_id])
      @logged_in_user = User.find_by_id(session[:user_id])
      if @customer && @customer.user.business.id == session[:business_id] || @customer && @customer.user.id == session[:user_id] || @customer && @logged_in_user && @logged_in_user.admin && @logged_in_user.business == @customer.business
  	    @note = Note.new(note_params)
  	    if @note.save
          respond_to do |format|
            format.js { render partial: "create_note" }
          end
  	    	# redirect_back(fallback_location: root_path)
  	    else
  	    	@errors = @note.errors.full_messages
  	    	render 'new'
  	    end
      elsif session[:business_id] || session[:user_id]
        redirect_to "/"
      else
        redirect_to "/"
      end
    end

    def destroy
      @note = Note.find(params[:id])
      @customer = Customer.find_by_id(@note.customer_id)
      @logged_in_user = User.find_by_id(session[:user_id])
      if @customer && @customer.user.business.id == session[:business_id] || @customer && @customer.user.id == session[:user_id] || @customer && @logged_in_user && @logged_in_user.admin && @logged_in_user.business == @customer.business
	  	  @note.destroy
	  	  redirect_back(fallback_location: root_path)
      elsif session[:business_id] || session[:user_id]
        redirect_to "/"
      else
        redirect_to "/"
      end
	  end

    private
    def note_params
    	params.require(:note).permit(:description, :customer_id)
    end
end
