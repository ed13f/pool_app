module ResetsHelper
  def prepare_reset
    @reset.email = reset_params[:email]
    @reset.temp_pass = rand_password=('a'..'z').to_a.shuffle.first(8).join
    @reset.person_id_num = @reset_person.id
    @reset.reset_type = reset_params[:reset_type]
    @reset.save
  end

  def find_reset_person
    if @reset.reset_type == "User"
      @reset_person = User.find_by_id(params[:id])
    elsif  @reset.reset_type == "Business"
      @reset_person = Business.find_by_id(params[:id])
    end
  end



end
