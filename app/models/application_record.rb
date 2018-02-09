class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true
   # - %l:%M%P

  def eastern_standard_time
    self.created_at.in_time_zone('Eastern Time (US & Canada)').strftime("%m/%d/%y")
  end

  def coordinates
  	coordinates_obj = {:latitude => self.latitude, :longitude => self.longitude}
  	# coordinates_obj.latitude = self.latitude
  	# coordinates_obj.longitude = self.longitude
  	puts coordinates_obj
  	coordinates_obj.to_json
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
end
