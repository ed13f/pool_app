module SessionsHelper
	def log_in(user)
    	session[:user_id] = user.id
  	end

  	def logged_in?
    	!!current_user
  	end

  	def log_out
    	reset_session
    	# session.delete(:user_id)
    	# session.delete(:business_id)
    	@current_user = nil
  	end
end
