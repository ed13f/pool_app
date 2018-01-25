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
      if person && person.authenticate(params[:password])
          session[session_type] = person.id
          redirect_to person
      else
          render 'new'
      end
    end
end
