class UserMailer < ApplicationMailer
  default from: 'noreply@example.com'
 
  def welcome_email(user)
    @user = user
    @url  = ENV['HOSTNAME']
    mail(to: @user.email, subject: 'Welcome to your Brokers app')
  end

  def client_referred_email(sender, destination, client)    
    begin      
      @sneder = sender
      @destination = destination
      @client = client
      mail(to: @destination.email, subject: "BrokersApp: New Client Referral")  
    rescue => exception
      puts "the notification email not was deliver"
    end
    
  end

  def client_updated_status(current_user, client_id) 
    @client = Client.find(client_id)
    @broker =Broker.find(current_user.broker.id)
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
