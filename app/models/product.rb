class Product < ApplicationRecord
  belongs_to :user
  has_many :comments, dependent: :destroy
  has_many :line_items, dependent: :destroy
  has_many_attached :uploads

  validates :title, presence: true, length: { minimum: 5, maximum: 70 }
  validates :price, numericality: { greater_than: 0.00 }
  validates :quantity, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validates :serial_no, presence: true
  validates :user, presence: true

  before_validation :add_serial_no

  after_save ThinkingSphinx::RealTime.callback_for(:product)

  after_destroy :purge_uploads

  def add_serial_no
    self.serial_no = self.user_id.to_s + "-" + DateTime.now.strftime("%Y%m%d%H%M%S")
  end

  def purge_uploads
    self.uploads.purge_later
  end
end
