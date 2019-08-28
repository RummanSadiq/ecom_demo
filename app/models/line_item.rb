class LineItem < ApplicationRecord
  scope :cart_items, -> { where(item_state: "cart") }
  scope :order_items, -> { where(item_state: "order") }

  belongs_to :product
  belongs_to :user

  validates :user, presence: true
  validates :product, presence: true

  validates :quantity,
            numericality: { only_integer: true,
                            greater_than: 1, less_than_or_equal_to: :get_product_quantity }

  def get_product_quantity
    return self.product.quantity
  end
end
