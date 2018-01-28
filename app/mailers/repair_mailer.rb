class RepairMailer < ApplicationMailer
  def repair_open(repair)
      @repair = repair
      @url  = 'http://example.com/login'
      mail(to: @repair.user.email, subject: 'New Pool Repair Open')
  end

  def repair_complete(repair)
      @repair = repair
      @url  = 'http://example.com/login'
      mail(to: @repair.customer.email, subject: 'Your Pool Repair has been ')
  end
end
