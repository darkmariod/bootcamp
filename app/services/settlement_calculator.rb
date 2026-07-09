# Calculates a labor settlement (liquidacion / finiquito) under the
# Ecuadorian Codigo del Trabajo.
#
# Components:
# - Pending salary for days worked in the final month.
# - Decimo tercer sueldo: 1/12 of earnings from Dec 1 to termination (Art. 111).
# - Decimo cuarto sueldo: proportional SBU by regional period (Art. 113).
#   Costa/Insular: Mar 1 - Feb 28. Sierra/Oriente: Aug 1 - Jul 31.
# - Unused vacation: 1/24 of earnings in the current vacation year, minus days
#   already taken (Arts. 69-71).
# - Desahucio bonus: 25% of the last monthly wage per year of service (Art. 185).
# - Severance for wrongful dismissal (despido intempestivo): 3 months minimum,
#   1 month per year of service (fractions count as a full year), 25 max (Art. 188).
# - Reserve funds: 8.33% monthly after the first year, when not paid monthly.
class SettlementCalculator
  SBU = 482.00 # Salario Basico Unificado 2026

  TERMINATION_REASONS = %i[despido_intempestivo renuncia_desahucio acuerdo_mutuo visto_bueno_empleador].freeze
  REGIONS = %i[sierra_oriente costa_insular].freeze

  Result = Struct.new(
    :monthly_salary, :start_date, :end_date, :years_of_service, :service_text,
    :line_items, :total_amount,
    keyword_init: true
  )

  LineItem = Struct.new(:concept, :legal_basis, :amount, keyword_init: true)

  def initialize(monthly_salary:, start_date:, end_date:, termination_reason:,
                 region: :sierra_oriente, vacation_days_taken: 0, fondos_reserva_paid: true)
    @salary = monthly_salary.to_f
    @start_date = start_date.to_date
    @end_date = end_date.to_date
    @reason = termination_reason.to_sym
    @region = region.to_sym
    @vacation_days_taken = vacation_days_taken.to_i
    @fondos_reserva_paid = fondos_reserva_paid
  end

  def call
    raise ArgumentError, "La fecha de salida debe ser posterior al ingreso" if @end_date <= @start_date

    items = []
    items << pending_salary
    items << decimo_tercero
    items << decimo_cuarto
    items << unused_vacation
    items << desahucio_bonus if pays_desahucio_bonus?
    items << severance if @reason == :despido_intempestivo
    items << reserve_funds unless @fondos_reserva_paid
    items.compact!

    Result.new(
      monthly_salary: @salary.round(2),
      start_date: @start_date,
      end_date: @end_date,
      years_of_service: years_of_service.round(2),
      service_text: service_text,
      line_items: items,
      total_amount: items.sum(&:amount).round(2)
    )
  end

  private

  def years_of_service
    (@end_date - @start_date).to_f / 365.25
  end

  def service_text
    years = ((@end_date - @start_date).to_i / 365.25).floor
    months = (((@end_date - @start_date).to_i % 365.25) / 30.44).floor
    "#{years} años, #{months} meses"
  end

  def daily_salary
    @salary / 30.0
  end

  def pending_salary
    days = @end_date.day
    LineItem.new(
      concept: "Sueldo pendiente del último mes (#{days} días)",
      legal_basis: "Remuneración devengada",
      amount: (daily_salary * days).round(2)
    )
  end

  # Period runs Dec 1 - Nov 30. Proportional over days worked in the period.
  def decimo_tercero
    period_start = Date.new(@end_date.month == 12 ? @end_date.year : @end_date.year - 1, 12, 1)
    from = [ period_start, @start_date ].max
    days = (@end_date - from).to_i + 1
    earned = @salary * days / 30.0
    LineItem.new(
      concept: "Décimo tercer sueldo proporcional (#{days} días)",
      legal_basis: "Art. 111 Código del Trabajo",
      amount: (earned / 12).round(2)
    )
  end

  def decimo_cuarto
    month = @region == :costa_insular ? 3 : 8
    period_start = Date.new(@end_date.year, month, 1)
    period_start = period_start.prev_year if period_start > @end_date
    from = [ period_start, @start_date ].max
    days = (@end_date - from).to_i + 1
    LineItem.new(
      concept: "Décimo cuarto sueldo proporcional (#{days} días, región #{@region == :costa_insular ? 'Costa/Insular' : 'Sierra/Oriente'})",
      legal_basis: "Art. 113 Código del Trabajo",
      amount: (SBU * days / 365.0).round(2)
    )
  end

  # 1/24 of earnings in the current vacation year (equivalent to 15 paid days),
  # minus vacation days already taken.
  def unused_vacation
    anniversary = @start_date + ((@end_date - @start_date).to_i / 365.25).floor.years
    days = (@end_date - anniversary).to_i + 1
    earned = @salary * days / 30.0
    amount = earned / 24 - (daily_salary * @vacation_days_taken)
    LineItem.new(
      concept: "Vacaciones no gozadas del período en curso (#{days} días acumulados#{@vacation_days_taken.positive? ? ", #{@vacation_days_taken} días tomados" : ''})",
      legal_basis: "Arts. 69-71 Código del Trabajo",
      amount: [ amount, 0 ].max.round(2)
    )
  end

  def pays_desahucio_bonus?
    %i[despido_intempestivo renuncia_desahucio acuerdo_mutuo].include?(@reason)
  end

  def desahucio_bonus
    LineItem.new(
      concept: "Bonificación por desahucio (25% del último sueldo por año de servicio)",
      legal_basis: "Art. 185 Código del Trabajo",
      amount: (@salary * 0.25 * years_of_service).round(2)
    )
  end

  # Fractions of a year count as a complete year (Art. 188).
  def severance
    years = [ years_of_service.ceil, 3 ].max.clamp(3, 25)
    LineItem.new(
      concept: "Indemnización por despido intempestivo (#{years} remuneraciones)",
      legal_basis: "Art. 188 Código del Trabajo",
      amount: (@salary * years).round(2)
    )
  end

  def reserve_funds
    total_days = (@end_date - @start_date).to_i
    return nil if total_days <= 365

    months_after_first_year = (total_days - 365) / 30.44
    LineItem.new(
      concept: "Fondos de reserva no pagados (#{months_after_first_year.floor} meses)",
      legal_basis: "Art. 196 Código del Trabajo",
      amount: (@salary * 0.0833 * months_after_first_year).round(2)
    )
  end
end
