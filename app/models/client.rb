class Client < ApplicationRecord
  belongs_to :user
  has_many :invoices, dependent: :destroy
  has_many :transactions, dependent: :nullify

  validates :name, :email, presence: true

  def total_invoiced
    invoices.sum(:amount)
  end

  def total_pending
    invoices.where(status: :pendiente).sum(:amount)
  end

  def total_income
    transactions.where(kind: :gasto_cliente).sum(:amount)
  end

  def total_expenses
    transactions.where(kind: :gasto_personal).sum(:amount)
  end
end
