class User < ApplicationRecord
	has_many :visits
  	has_many :customers
  	has_many :routes
  	has_many :customer_visits, through: :visits, source: :customer
  	belongs_to :business
    has_many :repairs, through: :business, source: :repairs
    has_secure_password

  	def full_name
    	self.first_name + " " + self.last_name
  	end

    def finished_pools
      # binding.pry

      # scheduled_days = self.customers.select do |customer|
      #   customer.days.days_list.count < 0
      # end
      # scheduled_days
    end
end
