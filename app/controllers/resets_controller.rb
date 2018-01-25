class ResetsController < ApplicationController
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
      @reset.email = reset_params[:email]
      @reset.temp_pass = rand_password=('a'..'z').to_a.shuffle.first(8).join
      @reset.person_id_num = @reset_person.id
      @reset.reset_type = reset_params[:reset_type]
      @reset.save
    else
      @reset = Reset.new
      @reset.email = reset_params[:email]
      @reset.temp_pass = rand_password=('a'..'z').to_a.shuffle.first(8).join
      @reset.person_id_num = @reset_person.id
      @reset.reset_type = reset_params[:reset_type]
      @reset.save
     end
    if @reset_person
     ResetMailer.reset_password(@reset_person, @reset).deliver
    end
  end

  def edit
    @user = User.find_by_id(params[:id])
    @reset = Reset.new
    # @reset = Reset.find_by(email: @user.email)
  end

  def update
    @reset = Reset.find_by(temp_pass: reset_params[:temp_pass])
    if @reset.reset_type == "User"
      @reset_person = User.find_by_id(params[:id])
    elsif  @reset.reset_type == "Business"
      @reset_person = Business.find_by_id(params[:id])
    end
    if @reset.email == @reset_person.email
      if @reset.reset_type == "User"
        session[:user_id] = @reset_person.id
      elsif  @reset.reset_type == "Business"
        session[:business_id] = @reset_person.id
      end
      @reset_person.update_attributes({:password => reset_params[:password_digest]})
      @reset.destroy
      redirect_to controller: "users", action:'show', :id => @reset_person.id
    else
      redirect_to "/"
    end
  end

  private
    def reset_params
      params.require(:reset).permit(:email, :temp_pass, :user_id, :new_pass, :reset_type, :password_digest)
    end
end
