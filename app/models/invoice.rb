class Invoice < ApplicationRecord
  belongs_to :user
  belongs_to :client

  validates :name, :amount, :issue_date, presence: true

  enum status: { pendiente: 0, pagada: 1, vencida: 2 }
end
