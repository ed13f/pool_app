class ResetsController < ApplicationController
  include ResetsHelper
  def new
    if session[:business_id] || session[:user_id]
      root_redirect_path
    else  
      @reset = Reset.new
    end  
  end

  def create
    if reset_params[:email] == "" 
      flash[:notice] = "Required Feilds(*)"
      redirect_to '/resets' 
    elsif reset_params[:reset_type] == "User"
      @reset_person = User.find_by(email: reset_params[:email])
      if @reset_person
        @reset = Reset.find_by(email: @reset_person.email)
      else
        flash[:notice] = "User Not Found"
        redirect_to '/resets'
      end  
    elsif reset_params[:reset_type] == "Business"
      if @reset_person = Business.find_by(email: reset_params[:email])
        @reset = Reset.find_by(email: @reset_person.email)
      else
        flash[:notice] = "User Not Found"
        redirect_to '/resets'
      end    
    end
    if @reset
      prepare_reset
    elsif reset_params[:email] != "" && @reset_person
      @reset = Reset.new
      prepare_reset
    end
    # @reset_person ? ResetMailer.reset_password(@reset_person, @reset).deliver : nil
    if @reset_person
      respond_to do |format|
        format.js { render partial: "reset_message" }
      end 
    end  
  end

  def edit
    if session[:business_id] || session[:user_id]
      root_redirect_path
    else  
      @user = User.find_by_id(params[:id])
      @reset = Reset.new
    end
  end

  def update
    if reset_params[:temp_pass] == "" || reset_params[:password_digest] == ""
      flash[:notice] = "Required Feilds(*)"
      redirect_to "/resets/" + params[:id].to_s
    else 
      if @reset = Reset.find_by(temp_pass: reset_params[:temp_pass])
        @reset_person = find_reset_person
      end  
      if @reset && @reset_person && @reset.email == @reset_person.email
        if @reset.reset_type == "User"
          session[:user_id] = @reset_person.id
        elsif  @reset.reset_type == "Business"
          session[:business_id] = @reset_person.id
        end
        @reset_person.update_attributes({:password => reset_params[:password_digest]})
        @reset.destroy
        redirect_to @reset_person
      else
        flash[:notice] = "Incorrect Credentials"
        redirect_to "/resets/" + params[:id].to_s
      end
    end  
  end

  private
    def reset_params
      params.require(:reset).permit(:email, :temp_pass, :user_id, :new_pass, :reset_type, :password_digest)
    end
end
