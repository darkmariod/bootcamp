class Category < ApplicationRecord
  belongs_to :user
  has_many :transactions, dependent: :nullify

  validates :name, presence: true
  validates :group, presence: true

  enum group: {
    ingreso_fijo: 0,
    egreso_necesario: 1,
    egreso: 2,
    egreso_compra: 3,
    otro_egreso: 4,
    egreso_viaje: 5
  }
end
