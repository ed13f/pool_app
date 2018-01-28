module RepairsHelper
 def pool_completion_select(status)
  @session.repairs.where(complete: status)
 end

  def find_repairs_customer
    if @repair
      customer = @repair.customer
    else
      nil
    end
  end

end
