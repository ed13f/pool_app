class NotesController < ApplicationController
  include CustomersHelper
    def create
      @customer = Customer.find_by_id(note_params[:customer_id])
      @logged_in_user = User.find_by_id(session[:user_id])
      customer_allow_user_business_or_admin
  	    @note = Note.new(note_params)
	    if @note.save
        respond_to do |format|
          format.js { render partial: "create_note" }
        end
	    else
        @errors = @note.errors.messages.keys
        @errors = {note: @errors, customer_id: @customer.id}
        respond_to do |format|
          format.js { render partial: "application/ajax_error_handling", locals: {errors: @errors} }
        end
	    end
    end

    def destroy
      @note = Note.find(params[:id])
      @customer = Customer.find_by_id(@note.customer_id)
      @logged_in_user = User.find_by_id(session[:user_id])
      customer_allow_user_business_or_admin
  	  @note.destroy
      respond_to do |format|
        format.js { render partial: "delete_note" }
      end
	  end

    private
    def note_params
    	params.require(:note).permit(:description, :customer_id)
    end
end
