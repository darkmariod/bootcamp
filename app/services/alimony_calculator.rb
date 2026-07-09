# Calculates the minimum child support pension (pension alimenticia minima)
# according to Acuerdo Ministerial MDH-DM-2026-0005-A (Ecuador, 2026).
#
# Legal rules implemented:
# - Income is net of the IESS employee contribution (Sentencia 048-13-SCN-CC).
# - Incomes below 1 SBU use the SBU as reference minimum (Disposicion General Primera).
# - The level is determined using the TOTAL number of children, even if not all
#   of them claim the pension; the amount is divided among all children and the
#   claimed portion is the resulting pension (Art. 13).
# - With children of different ages, the percentage of the oldest applies (Art. 14).
# - The disability supplement is per household, using the highest disability
#   percentage among the children (Art. 10).
class AlimonyCalculator
  SBU = 482.00 # Salario Basico Unificado 2026 (Acuerdo MDT-2025-195)
  IESS_RATE = 0.0945

  # Percentages of income by level -> children count -> age group.
  # Levels 3..6 apply a single percentage regardless of the number of children.
  TABLE = {
    1 => { 1 => { under_3: 28.12, three_plus: 29.49 },
           2 => { under_3: 39.71, three_plus: 43.13 },
           3 => { under_3: 52.18, three_plus: 54.23 } },
    2 => { 1 => { under_3: 34.84, three_plus: 36.96 },
           2 => { under_3: 47.45, three_plus: 49.51 } },
    3 => { 1 => { under_3: 38.49, three_plus: 40.83 } },
    4 => { 1 => { under_3: 39.79, three_plus: 42.21 } },
    5 => { 1 => { under_3: 41.14, three_plus: 43.64 } },
    6 => { 1 => { under_3: 42.53, three_plus: 45.12 } }
  }.freeze

  # Disability supplement as percentage of 1 SBU, per level and disability range.
  DISABILITY_TABLE = {
    1 => { d30_49: 4.56,  d50_74: 5.23,  d75_100: 6.63 },
    2 => { d30_49: 10.68, d50_74: 12.26, d75_100: 15.55 },
    3 => { d30_49: 18.23, d50_74: 20.92, d75_100: 26.53 },
    4 => { d30_49: 25.54, d50_74: 29.30, d75_100: 37.16 },
    5 => { d30_49: 30.43, d50_74: 34.92, d75_100: 44.28 },
    6 => { d30_49: 30.43, d50_74: 34.92, d75_100: 44.28 }
  }.freeze

  # Upper bound of each level expressed in SBU multiples.
  LEVEL_BOUNDS = { 1 => 1.25, 2 => 3.0, 3 => 4.0, 4 => 6.5, 5 => 9.0 }.freeze

  Result = Struct.new(
    :gross_income, :net_income, :reference_income, :sbu_multiple, :level,
    :age_group, :total_children, :claimed_children, :percentage, :base_amount,
    :disability_supplement, :total_amount, :per_child_amount, :pension_amount,
    keyword_init: true
  )

  def initialize(monthly_income:, children_under_3: 0, children_3_plus: 0,
                 claimed_children: nil, iess_deducted: false, disability_range: :none)
    @monthly_income = monthly_income.to_f
    @children_under_3 = children_under_3.to_i
    @children_3_plus = children_3_plus.to_i
    @total_children = @children_under_3 + @children_3_plus
    @claimed_children = (claimed_children.presence || @total_children).to_i.clamp(1, [ @total_children, 1 ].max)
    @iess_deducted = iess_deducted
    @disability_range = disability_range.to_sym
  end

  def call
    raise ArgumentError, "Debe existir al menos un hijo" if @total_children < 1

    net = @iess_deducted ? @monthly_income : @monthly_income * (1 - IESS_RATE)
    reference = [ net, SBU ].max
    multiple = reference / SBU
    level = level_for(multiple)
    age_group = @children_3_plus.positive? ? :three_plus : :under_3
    percentage = percentage_for(level, @total_children, age_group)

    base = reference * percentage / 100
    supplement = disability_supplement_for(level)
    total = base + supplement
    per_child = total / @total_children
    pension = per_child * @claimed_children

    Result.new(
      gross_income: @monthly_income.round(2),
      net_income: net.round(2),
      reference_income: reference.round(2),
      sbu_multiple: multiple.round(4),
      level: level,
      age_group: age_group,
      total_children: @total_children,
      claimed_children: @claimed_children,
      percentage: percentage,
      base_amount: base.round(2),
      disability_supplement: supplement.round(2),
      total_amount: total.round(2),
      per_child_amount: per_child.round(2),
      pension_amount: pension.round(2)
    )
  end

  private

  def level_for(multiple)
    LEVEL_BOUNDS.each { |level, bound| return level if multiple <= bound }
    6
  end

  def percentage_for(level, children, age_group)
    rows = TABLE.fetch(level)
    key = [ children, rows.keys.max ].min
    rows.fetch(key).fetch(age_group)
  end

  def disability_supplement_for(level)
    return 0.0 if @disability_range == :none

    SBU * DISABILITY_TABLE.fetch(level).fetch(@disability_range) / 100
  end
end
