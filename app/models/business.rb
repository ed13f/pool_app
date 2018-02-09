class Business < ApplicationRecord
	has_many :users
	has_many :customers, through: :users
	has_many :repairs, through: :customers, source: :repairs
	has_secure_password
	accepts_nested_attributes_for :users
	validates :owners_first_name, :presence => true
	validates :owners_last_name, :presence => true
	validates :business_name, :presence => true
	validates :phone, :presence => true
	validates :email, :presence => true

	def number_of_customers
		self.customers.count
	end

	def number_of_employees
		self.users.count
	end

	def customer_to_employee_ratio
		if number_of_customers > 0 && number_of_employees > 0
			number_of_customers / number_of_employees
		end
	end

	def repairs_status_alphabetical_sort(status)
    	self.repairs.where(complete: status).order(:last_name)
	end 

	def customer_alphabetical_sort
	    self.customers.order(:last_name)
	end  

	def display_customer_name_by_last
		self.last_name + ", " + self.first_name
	end	
end
