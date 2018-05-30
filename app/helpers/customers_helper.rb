module CustomersHelper
  def user_or_business_logged_in
    if session[:business_id] || session[:user_id]
    else
      flash[:notice] = "Not Authorized To View This Page"
      root_redirect_path
    end
  end

  def assign_user_id
    if customer_params[:user_id] == "" || customer_params[:user_id] == nil
      if session[:user_id]
        id = session[:user_id]
      end
    else
      id = customer_params[:user_id]
    end
  end

  def customer_business?
    @customer && @customer.user.business.id == session[:business_id]
  end

  def customer_user?
    @customer && @customer.user.id == session[:user_id]
  end

  def customer_user_logged_in?
    @customer && @logged_in_user && @logged_in_user.admin && @logged_in_user.business == @customer.business
  end


  def customer_allow_user_business_or_admin
    if customer_business? || customer_user? || customer_user_logged_in?
    else
      root_redirect_path
    end
  end

  def allow_only_user_and_admin
    if customer_user? || customer_user_logged_in?
    else
      root_redirect_path
    end
  end
end
