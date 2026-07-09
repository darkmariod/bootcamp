class Transaction < ApplicationRecord
  belongs_to :user
  belongs_to :category, optional: true
  belongs_to :client, optional: true

  validates :description, :amount, :date, :kind, presence: true

  enum kind: { ingreso: 0, gasto_personal: 1, gasto_cliente: 2 }

  scope :by_user, ->(user) { where(user: user) }
  scope :by_month, ->(date) { where(date: date.beginning_of_month..date.end_of_month) }
end
