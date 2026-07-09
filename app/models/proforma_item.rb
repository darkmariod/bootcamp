class ProformaItem < ApplicationRecord
  belongs_to :proforma, inverse_of: :proforma_items

  validates :description, presence: true
  validates :quantity, numericality: { greater_than: 0 }
  validates :unit_price, numericality: { greater_than_or_equal_to: 0 }

  def subtotal
    (quantity.to_f * unit_price.to_f).round(2)
  end
end
