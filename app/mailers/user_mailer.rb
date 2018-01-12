class UserMailer < ApplicationMailer
	def welcome_email(user)
    	@user = user
    	@url  = 'http://example.com/login'
    	mail(to: @user.email, subject: 'Welcome to the Team!')
  	end

  	def reset_password(user)
  		@user = user
    	@url  = 'http://localhost:3000/reset_password/' + @user.id.to_s
    	mail(to: @user.email, subject: 'Password Reset')
  	end	
end
