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
    mail(to: @agent.email, subject: "BrokersApp: New Client Referral")
  end

  def client_updated_status(broker_id, client_id)    
    @client = Agent.find(client_id)
    @broker = Broker.find(broker_id)
    @url  = ENV['HOSTNAME']
    @user_status = User.find(@client.user_id).user_state
    mail(to: @client.user.email, subject: "BrokersApp: User activation")
  end

  def broker_actived_from_admin(user_id)
    user = User.find(user_id)
    @full_name = user.full_name    
    @url  = ENV['HOSTNAME']
    @user_status = user.user_state
    mail(to: user.email, subject: "BrokersApp: User activation")
  end
end
