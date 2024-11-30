class Order < ApplicationRecord
  belongs_to :user
  has_many :order_items, dependent: :destroy
  has_many :products, through: :order_items

  validates :phone, :address, presence: true

  before_create :calculate_total_price
  after_update :update_sold_product, if: -> { self.completed? }

  enum status: %i(wait_confirm delivering completed canceled)

  scope :this_month, -> { where(created_at: Time.zone.now.all_month) }
  default_scope { order(id: :desc) }

  private

  def update_sold_product
    self.order_items.each do |order_item|
      sold = order_item.product.sold.to_i
      order_item.product.update(sold: sold + order_item.quantity)
    end
  end

  def calculate_total_price
    self.total_price = order_items.sum { |item| item.product.price * item.quantity }
  end
end
