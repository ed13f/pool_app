class CustomerMailer < ApplicationMailer
	def new_customer(customer)
    	@customer = customer
    	@url  = 'http://example.com/login'
    	mail(to: @customer.email, subject: 'Welcome to the Pool App!')
    end
end
