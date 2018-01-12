class User < ApplicationRecord
	has_many :visits
  	has_many :customers
  	has_many :routes
  	has_many :customer_visits, through: :visits, source: :customer
  	has_secure_password
  	belongs_to :business

  	def full_name
    	self.first_name + " " + self.last_name
  	end
end
