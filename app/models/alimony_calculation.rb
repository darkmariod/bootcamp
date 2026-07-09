class AlimonyCalculation < ApplicationRecord
  belongs_to :user
  belongs_to :legal_case, optional: true

  enum :disability_range, { none: 0, d30_49: 1, d50_74: 2, d75_100: 3 }, prefix: :disability

  validates :monthly_income, numericality: { greater_than: 0 }
  validates :applicant_name, presence: true
  validate :at_least_one_child

  DISABILITY_LABELS = {
    "none" => "Sin discapacidad", "d30_49" => "30% - 49%",
    "d50_74" => "50% - 74%", "d75_100" => "75% - 100%"
  }.freeze

  def disability_label = DISABILITY_LABELS[disability_range]

  def compute!
    result = AlimonyCalculator.new(
      monthly_income: monthly_income,
      children_under_3: children_under_3,
      children_3_plus: children_3_plus,
      claimed_children: claimed_children,
      iess_deducted: iess_deducted,
      disability_range: disability_range.to_sym
    ).call

    assign_attributes(
      level: result.level,
      percentage: result.percentage,
      total_amount: result.total_amount,
      per_child_amount: result.per_child_amount,
      pension_amount: result.pension_amount,
      disability_supplement: result.disability_supplement,
      claimed_children: result.claimed_children,
      details: {
        gross_income: result.gross_income,
        net_income: result.net_income,
        reference_income: result.reference_income,
        sbu_multiple: result.sbu_multiple,
        age_group: result.age_group,
        base_amount: result.base_amount,
        total_children: result.total_children
      }
    )
    self
  end

  private

  def at_least_one_child
    if children_under_3.to_i + children_3_plus.to_i < 1
      errors.add(:base, "Debe registrar al menos un hijo o hija")
    end
  end
end
