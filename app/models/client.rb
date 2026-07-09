class Client < ApplicationRecord
  has_many :legal_cases, dependent: :destroy

  validates :name, presence: true
  validates :cedula, presence: true, uniqueness: true

  def self.search(term)
    return all if term.blank?

    where("name ILIKE :t OR cedula ILIKE :t OR email ILIKE :t", t: "%#{sanitize_sql_like(term)}%")
  end
end
