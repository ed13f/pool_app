module BusinessesHelper
  def reset_pools
    @customers.map do |customer|
        customer.weekly_complete = false
        customer.weekly_visit_str = ""
        customer.save
      end
  end

  def select_pools_completed_status(complete_status)
    @customers.select{ |customer| customer.weekly_complete == complete_status }
  end

  def customer_alphabetical_sort
    self.customers.order(:last_name)
  end  
end
