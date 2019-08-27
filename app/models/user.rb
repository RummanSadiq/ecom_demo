class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :products, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :line_items, dependent: :destroy

  has_many :cart_items, -> { where(item_state: "cart") }, class_name: "LineItem"
  has_many :order_items, -> { where(item_state: "order") }, class_name: "LineItem"
end
