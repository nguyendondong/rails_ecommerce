class Product < ApplicationRecord
  RANSACABLE_ATTRIBUTES = %w(name price body)
  RANSACABLE_ASSOCIATIONS = %w(action_text_rich_text category)

  belongs_to :category
  has_many :order_items, dependent: :destroy
  has_one :action_text_rich_text, class_name: "ActionText::RichText", as: :record

  validates :name, presence: true, length: { maximum: Settings.product.validates.name.max }
  validates :price, presence: true, numericality: { greater_than: Settings.product.validates.price.min,
                                    less_than_or_equal_to: Settings.product.validates.price.max }
  validates :status, presence: true, inclusion: { in: %w(enabled disabled) }

  enum status: %i(enabled disabled)

  scope :recommended, -> { order("RAND()").limit(Settings.display.slides.product_items) }
  scope :best_sellers, -> { order(sold: :desc).limit(Settings.display.slides.product_items) }
  scope :new_arrival, -> { order(created_at: :desc).limit(Settings.display.slides.product_items) }
  scope :search, -> (search_term) {
    joins(:action_text_rich_text, :category)
      .where("products.name LIKE :search OR action_text_rich_texts.body LIKE :search OR categories.name LIKE :search",
      search: "%#{search_term}%")
  }

  has_one_attached :image, dependent: :destroy
  has_rich_text :body
end
