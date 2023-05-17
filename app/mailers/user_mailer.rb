class UserMailer < ApplicationMailer
  default from: 'noreply@example.com'
 
  def welcome_email(user)
    @user = user
    @url  = ENV['HOSTNAME']
    mail(to: @user.email, subject: 'Welcome to your Brokers app')
  end

  def client_referred_email(referral)
    @referral = referral
    @agent = @referral.agent
    @client = @referral.client
    mail(to: @agent.email, subject: "New Client Referral")
  end

  def client_updated_status(broker_id, client_id)    
    @client = Agent.find(client_id)
    @broker = Broker.find(broker_id)
    @url  = ENV['HOSTNAME']    
    @user_status = User.find(@broker.user_id).user_state
    mail(to: @client.email, subject: "New Client Referral")
  end
end
