class UserMailer < ApplicationMailer
  default from: 'notifications@example.com'
 
  def welcome_email
    @user = params[:user]
    @url  = 'http://example.com/login'
    mail(to: @user.email, subject: 'Welcome to your Brokers app')
  end

  def client_referred_email(referral)
    @referral = referral
    @agent = @referral.agent
    @client = @referral.client
    mail(to: @agent.email, subject: "New Client Referral")
  end
end
