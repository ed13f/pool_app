class Customer < ApplicationRecord
	belongs_to :user
  	has_many :visits
  	has_many :repairs
  	has_many :notes
  	has_many :days

  	geocoded_by :full_address
  	after_validation :geocode 

  	has_attached_file :avatar, styles: { medium: "300x300>", thumb: "100x100>" }, default_url: "/images/:style/missing.png"
  	validates_attachment_content_type :avatar, content_type: /\Aimage\/.*\z/

  	def full_name
    	self.first_name + " " + self.last_name
  	end

  	def reset_pool_completion
    	pools = Customer.all
      		pools.each do |pool|
        	pool.weekly_complete = false
        	pool.save
    	end
  	end

  	# def coordinates
  	#   coord_obj = {latitude: self.latitude, longitude: self.longitude}
  	#   puts "coordinates-rico"
  	#   coord_obj
  	# end  

  	def full_address
    	self.street_address + " " + self.city + ", " + self.state + " " + self.zip_code
  	end   
end
