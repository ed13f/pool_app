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
end
