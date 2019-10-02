module ApplicationHelper
  def require_logged_in_user
    if !session[:business_id] && !session[:user_id]
      if session[:business_id]
        redirect_to :controller => 'businesses', :action => 'show', :id => session[:business_id]
      elsif session[:business_id]
        redirect_to :controller => 'users', :action => 'show', :id => session[:users_id]
      else
        redirect_to '/'
      end
    end
  end

  def root_redirect_path
    # binding.pry
    if session[:business_id]
      puts "busineessss redirect"
        redirect_to :controller => 'businesses', :action => 'show', id: session[:business_id]
      elsif session[:user_id]
        redirect_to :controller => 'users', :action => 'show', id: session[:user_id]
      else
        redirect_to :controller => 'sessions', :action => 'new'
      end
  end

  def logged_in_user_admin?
    @logged_in_user && @logged_in_user.admin && @logged_in_user.business == @business
  end

  def logged_in_business?
    @business && @business.id == session[:business_id]
  end

  def allow_business_and_admin_access
    if logged_in_business? || logged_in_user_admin?
    else
      root_redirect_path
    end
  end

  def customer_search(search, customers)
      if  !customers.nil?
        if search
          # @pools = self.customers
          customers.where("LOWER(customers.first_name) LIKE ?
          OR LOWER(customers.last_name) LIKE ?
          OR LOWER(customers.phone) LIKE ?
          OR LOWER(customers.email) LIKE ?
          OR LOWER(customers.street_address) LIKE ?
          OR LOWER(customers.city) LIKE ?
          OR LOWER(customers.state) LIKE ?
          OR LOWER(customers.zip_code) LIKE ?
          OR LOWER(customers.filter_type) LIKE ?
          OR LOWER(customers.pump_type) LIKE ?", "%#{search.downcase}%", "%#{search.downcase}%", "%#{search.downcase}%", "%#{search.downcase}%", "%#{search.downcase}%", "%#{search.downcase}%", "%#{search.downcase}%", "%#{search.downcase}%", "%#{search.downcase}%", "%#{search.downcase}%")
        else
          # binding.pry
          customers
        end
      end 
  end
  def repairs_search(search, repairs)
      if  !repairs.nil?
        if search
          # @pools = self.customers
          repairs.where("LOWER(repairs.title) LIKE ? OR LOWER(repairs.description) LIKE ?", "%#{search.downcase}%", "%#{search.downcase}%")
        else
          # binding.pry
          repairs
        end
      end 
  end
  def employees_search(search, employees)
      if  !employees.nil?
        if search
          # @pools = self.customers
          employees.where("LOWER(users.first_name) LIKE ? OR LOWER(users.last_name) LIKE ?", "%#{search.downcase}%", "%#{search.downcase}%")
        else
          # binding.pry
          employees
        end
      end 
  end
end
