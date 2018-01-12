class Business < ApplicationRecord
	has_many :users
	has_many :customers, through: :users 
	has_many :repairs, through: :customers, source: :repairs

	def number_of_customers
		self.customers.count
	end	

	def number_of_employees
		self.users.count
	end	
	
	def customer_to_employee_ratio
		number_of_customers / number_of_employees
	end
end
