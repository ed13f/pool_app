class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  def eastern_standard_time
    self.created_at.in_time_zone('Eastern Time (US & Canada)').strftime("%m/%d/%y - %l:%M%P")
  end 
  
  def coordinates
  	coordinates_obj = {:latitude => self.latitude, :longitude => self.longitude}
  	# coordinates_obj.latitude = self.latitude
  	# coordinates_obj.longitude = self.longitude
  	puts coordinates_obj
  	coordinates_obj.to_json
  end	
end
