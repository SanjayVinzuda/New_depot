class Product < ActiveRecord::Base
  validates :title, :presence=>true#, :uniqueness=>true
  validates :descrption, :presence=>true
  validates :image_url, :presence=>true, :format => {:with=> %r{\.(gif|jpg|png)$}i,:message => 'must be a URL for GIF, JPG or PNG image.',:multiline => true}
  validates :price, :numericality => {:greater_than_or_equal_to => 0.01}, :length=> { in: 1..5 }

  default_scope { order(created_at: :desc) }
  #default_scope { where(title: 'lenovo') }
  has_many :line_items
  has_many :orders, through: :line_items

  before_destroy :ensure_not_referenced_by_any_line_item
  # ensure that there are no line items referencing this product
  def ensure_not_referenced_by_any_line_item
    if line_items.count.zero?
      return true
    else
      errors.add(:base,'Line Item present')
      return false
    end
  end
  def self.latest
    Product.order(:updated_at).last
  end
end
