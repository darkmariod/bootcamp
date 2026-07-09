class Proforma < ApplicationRecord
  belongs_to :client
  belongs_to :legal_case, optional: true
  belongs_to :user
  has_many :proforma_items, dependent: :destroy, inverse_of: :proforma

  accepts_nested_attributes_for :proforma_items, allow_destroy: true,
    reject_if: ->(attrs) { attrs["description"].blank? }

  enum :status, { borrador: 0, enviada: 1, aceptada: 2, rechazada: 3 }, default: :borrador

  validates :issued_on, presence: true
  validate :at_least_one_item

  before_create :assign_number
  before_save :compute_total

  STATUS_LABELS = {
    "borrador" => "Borrador", "enviada" => "Enviada",
    "aceptada" => "Aceptada", "rechazada" => "Rechazada"
  }.freeze

  def status_label = STATUS_LABELS[status]

  def self.search(term)
    return all if term.blank?

    joins(:client).where(
      "proformas.number ILIKE :t OR clients.name ILIKE :t",
      t: "%#{sanitize_sql_like(term)}%"
    )
  end

  private

  def at_least_one_item
    errors.add(:base, "Agregue al menos un rubro con descripción") if proforma_items.reject(&:marked_for_destruction?).empty?
  end

  def assign_number
    year = Date.current.year
    seq = self.class.where("number LIKE ?", "PRO-#{year}-%").count + 1
    self.number = format("PRO-%d-%03d", year, seq)
  end

  def compute_total
    self.total_amount = proforma_items.reject(&:marked_for_destruction?).sum(&:subtotal)
  end
end
