class VisitMailer < ApplicationMailer
	def visit_complete(visit)
	    @visit = visit
	    @url  = 'http://example.com/login'
	    mail(to: @visit.customer.email, subject: 'Visit Completed!')
	end
end
