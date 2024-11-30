class User < ApplicationRecord
  devise :database_authenticatable, :registerable, :rememberable, :validatable, 
            :recoverable, :lockable, :confirmable

  has_many :orders, dependent: :destroy
  has_many :order_items, through: :orders

  validates :name, presence: true, length: { maximum: Settings.user.validates.name.max }

  enum role: %i(user admin)
  enum status: %i(enabled disabled)

  def send_devise_notification(notification, *args)
    devise_mailer.send(notification, self, *args).deliver_later
  end

  def confirmation_required?
    return false if admin?
    super
  end

  def active_for_authentication?
    super && self.enabled?
  end

  def inactive_message
    "Sorry, your account no longer has access to these"
  end
end
