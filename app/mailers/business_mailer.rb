class BusinessMailer < ApplicationMailer
	def unfinished_pool_report(business, unfinished_pools)
    	@business = business
    	@unfinished_pools = unfinished_pools
    	@url  = 'http://example.com/login'
    	mail(to: @business.email, subject: 'Weekly Report From Pool App!')
    end
end
