FactoryBot.define do
  factory :user do
    first_name { 'javier' }
    last_name { 'pedroza' }
    username { 'Broker1' }
    email { 'broker1@gmail.com' }
    role { 'broker' }
    user_state { 'active' }
  end

  factory :broker do
    user { association :user }
  end

  factory :client do |u|
    u.role { 'client' }
  end

end