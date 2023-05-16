class UserMailer < ApplicationMailer
  default from: 'noreply@example.com'
 
  def welcome_email(user)
    @user = user
    @url  = ENV['HOSTNAME'] || 'https://sleepy-garden-18861.herokuapp.com/'
    mail(to: @user.email, subject: 'Welcome to your Brokers app')
  end

  def client_referred_email(referral)
    @referral = referral
    @agent = @referral.agent
    @client = @referral.client
    mail(to: @agent.email, subject: "New Client Referral")
  end
end
