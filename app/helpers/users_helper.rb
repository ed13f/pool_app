module UsersHelper
  include ApplicationHelper

    def user_allow_business_and_admin
      if session[:business_id] || @logged_in_user && @logged_in_user.admin
      else
        root_redirect_path
      end
    end

    def user_business?
      @user && session[:business_id] == @user.business.id
    end

    def user_current_user?
      @user && @user.id == session[:user_id]
    end

    def user_admin?
      @user && @logged_in_user && @logged_in_user.admin && @logged_in_user.business == @user.business
    end

    def user_allow_user_business_and_admin
      if user_business? || user_current_user? || user_admin?
      else
        root_redirect_path
      end
    end

    def assign_business_id
      if session[:business_id]
        @user.business_id = session[:business_id]
      elsif session[:user_id]
        @user.business_id = @logged_in_user.business.id
      end
    end

    # def todays_route
    #   @finished_route = @user.customers.select do |customer|
    #       customer.days_list.include?(Time.now.strftime("%A"))
    #     end
    # end
    def todays_route
      day = Time.now.strftime("%A").downcase
      days = ['monday','tuesday', 'wednesday', 'thursday', 'friday']
      if(days.include?(day))
        @todays_route = @user.customers.where(day => true)
      end
      
    end

    def select_finished_route
      @finished_route = @user.customers.select do |customer|
          customer.days_list.include?(Time.now.strftime("%A")) && customer.days_visited_list.include?(Time.now.strftime("%A"))
        end
    end

    def select_unfinished_route
      @unfinished_route = @user.customers.select do |customer|
          customer.days_list.include?(Time.now.strftime("%A")) && customer.weekly_complete == false && !customer.days_visited_list.include?(Time.now.strftime("%A"))
        end
    end
    def customer_search(search, pools)
      if  !pools.nil?
        if search
          # @pools = self.customers
          pools.where("LOWER(first_name) LIKE ? OR LOWER(last_name) LIKE ?", "%#{search.downcase}%", "%#{search.downcase}%")
        else
          # binding.pry
          pools
        end
      end 
  end



end
