class ResetsController < ApplicationController
  include ResetsHelper
  def new
    @reset = Reset.new
  end

  def create
    if reset_params[:reset_type] == "User"
      @reset_person = User.find_by(email: reset_params[:email])
      @reset = Reset.find_by(email: @reset_person.email)
    elsif reset_params[:reset_type] == "Business"
      @reset_person = Business.find_by(email: reset_params[:email])
      @reset = Reset.find_by(email: @reset_person.email)
    end
    if @reset
      prepare_reset
    else
      @reset = Reset.new
      prepare_reset
     end
     @reset_person ? ResetMailer.reset_password(@reset_person, @reset).deliver : nil
    respond_to do |format|
      format.js { render partial: "reset_message" }
    end
  end

  def edit
    @user = User.find_by_id(params[:id])
    @reset = Reset.new
  end

  def update
    @reset = Reset.find_by(temp_pass: reset_params[:temp_pass])
    @reset_person = find_reset_person
    if @reset.email == @reset_person.email
      if @reset.reset_type == "User"
        session[:user_id] = @reset_person.id
      elsif  @reset.reset_type == "Business"
        session[:business_id] = @reset_person.id
      end
      @reset_person.update_attributes({:password => reset_params[:password_digest]})
      @reset.destroy
      redirect_to @reset_person
    else
      redirect_to "/"
    end
  end

  private
    def reset_params
      params.require(:reset).permit(:email, :temp_pass, :user_id, :new_pass, :reset_type, :password_digest)
    end
end
