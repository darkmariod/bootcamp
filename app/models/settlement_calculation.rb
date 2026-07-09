class SettlementCalculation < ApplicationRecord
  belongs_to :user
  belongs_to :legal_case, optional: true

  enum :termination_reason, {
    despido_intempestivo: 0, renuncia_desahucio: 1, acuerdo_mutuo: 2, visto_bueno_empleador: 3
  }
  enum :region, { sierra_oriente: 0, costa_insular: 1 }

  validates :worker_name, presence: true
  validates :monthly_salary, numericality: { greater_than: 0 }
  validates :start_date, :end_date, presence: true
  validate :end_after_start

  REASON_LABELS = {
    "despido_intempestivo" => "Despido intempestivo",
    "renuncia_desahucio" => "Renuncia voluntaria (desahucio)",
    "acuerdo_mutuo" => "Acuerdo entre las partes",
    "visto_bueno_empleador" => "Visto bueno del empleador"
  }.freeze

  REGION_LABELS = {
    "sierra_oriente" => "Sierra / Oriente",
    "costa_insular" => "Costa / Insular"
  }.freeze

  def reason_label = REASON_LABELS[termination_reason]
  def region_label = REGION_LABELS[region]

  def compute!
    result = SettlementCalculator.new(
      monthly_salary: monthly_salary,
      start_date: start_date,
      end_date: end_date,
      termination_reason: termination_reason.to_sym,
      region: region.to_sym,
      vacation_days_taken: vacation_days_taken.to_i,
      fondos_reserva_paid: fondos_reserva_paid
    ).call

    assign_attributes(
      total_amount: result.total_amount,
      details: {
        years_of_service: result.years_of_service,
        service_text: result.service_text,
        line_items: result.line_items.map { |i| { concept: i.concept, legal_basis: i.legal_basis, amount: i.amount } }
      }
    )
    self
  end

  def line_items
    (details&.dig("line_items") || []).map(&:symbolize_keys)
  end

  private

  def end_after_start
    return if start_date.blank? || end_date.blank?

    errors.add(:end_date, "debe ser posterior a la fecha de ingreso") if end_date <= start_date
  end
end
