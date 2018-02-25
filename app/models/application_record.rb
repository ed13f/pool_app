class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true
   # - %l:%M%P

  def eastern_standard_time
    self.created_at.in_time_zone('Eastern Time (US & Canada)').strftime("%m/%d/%y")
  end
  def updated_eastern_standard_time
    self.updated_at.in_time_zone('Eastern Time (US & Canada)').strftime("%m/%d/%y")
  end

  def coordinates
  	coordinates_obj = {:latitude => self.latitude, :longitude => self.longitude}
  	# coordinates_obj.latitude = self.latitude
  	# coordinates_obj.longitude = self.longitude
  	puts coordinates_obj
  	coordinates_obj.to_json
  end
  
  def display_customer_name_by_last
    self.last_name + ", " + self.first_name
  end 

  def require_logged_in_user
    if !session[:business_id] && !session[:user_id]
      if session[:business_id]
        redirect_to :controller => 'businesses', :action => 'show', :id => session[:business_id]
      elsif session[:business_id]
        redirect_to :controller => 'users', :action => 'show', :id => session[:users_id]
      else
        redirect_to '/'
      end
    end
  end

  def phone_format
    phone_num = self.phone
    if phone_num.length == 11
      formatted_phone_num = phone_num.insert(1, '(').insert(5, ')').insert(9, '-')
    elsif phone_num.length== 10
      formatted_phone_num = phone_num.insert(0, '(').insert(4, ')').insert(8, '-')
    elsif phone_num.length == 7
      formatted_phone_num = phone_num.insert(3, '-')
    end  
  end  
end
