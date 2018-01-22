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
end
