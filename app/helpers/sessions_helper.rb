module SessionsHelper
	def log_in(user)
    	session[:user_id] = user.id
  	end

  	def logged_in?
    	!!current_user
  	end

  	def log_out
    	reset_session
    	@current_user = nil
  	end

    def authenticate_signin(person, object_type, session_type)
      person = object_type.find_by(email: params[:email])
      if person.class == User && person.active_employee == false
        flash[:notice] = "Employee is no longer active."
        redirect_to '/sessions/new' 
      elsif person && person.authenticate(params[:password])
        session[session_type] = person.id
        redirect_to person
      else
        flash[:notice] = "No User with those Credentials"
        redirect_to '/sessions/new'
      end
    end
end
