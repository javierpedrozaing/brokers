class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_one :broker, dependent: :destroy
  has_one :agent, dependent: :destroy
  has_one :client, dependent: :destroy
  has_one_attached :photo, dependent: :purge_later

  # after_create :send_notification_new_user

  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :phone, presence: true, :numericality => {:only_integer => true}

  after_create :send_confirm_registration_email

  def active_for_authentication?
    super && self.is_active?
  end

  def is_active?
    self.user_state.downcase == 'active'
  end

  def full_name
    "#{self.first_name} #{self.last_name}"     
  end

  def send_confirm_registration_email
    UserMailer.welcome_email(self).deliver_now
  end
end
