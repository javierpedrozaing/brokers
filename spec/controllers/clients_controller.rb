require 'rails_helper'

Rspec.describe ClientsController, type: :controller do 
  context 'Broker transactions' do
    it 'List all clients' do
      FactoryBot.create(:broker)
    end
  
    it 'Create a new client' do
      
    end

    it 'Show a client info' do
      
    end

    it 'Edit a client info' do
      
    end

    it 'can refer a broker' do 

    end

    it 'can refer an agent' do 
      
    end

  end

  context 'Agents transactions' do
    it 'an agent is able to create a client' do
      
    end

    it 'an agent is able to refer an client to brokers' do
      
    end


  end
end