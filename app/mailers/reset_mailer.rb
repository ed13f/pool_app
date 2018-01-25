class ResetMailer < ApplicationMailer
  def reset_password(user, reset)
      @user = user
      @reset = reset
      @url  = 'http://localhost:3000/resets/' + @user.id.to_s
      mail(to: @user.email, subject: 'Password Reset')
    end
end
