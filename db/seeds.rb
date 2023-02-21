# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

user = User.create! :id => 0, :first_name => 'dummy', :last_name => 'dummy', :phone => '1312313', :email => 'dummy@gmail.com', :password => '12345678', :password_confirmation => '12345678'

broker = Broker.create! :id => 0, :user_id => user.id, :agent_id => 0
agent = Agent.create! :id => 0, :user_id => user.id, :broker_id => broker.id