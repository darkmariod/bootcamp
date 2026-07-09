class SettlementCalculationsController < ApplicationController
  before_action :set_calculation, only: %i[show destroy send_email]

  def index
    @calculations = SettlementCalculation.includes(:user, :legal_case).order(created_at: :desc)
  end

  def new
    @calculation = SettlementCalculation.new(
      termination_reason: :despido_intempestivo, region: :sierra_oriente,
      vacation_days_taken: 0, fondos_reserva_paid: true
    )
  end

  def create
    @calculation = SettlementCalculation.new(calculation_params)
    @calculation.user = Current.user

    if @calculation.valid?
      @calculation.compute!
      @calculation.save!
      respond_to do |format|
        format.turbo_stream
        format.html { redirect_to @calculation }
      end
    else
      respond_to do |format|
        format.turbo_stream { render :errors, status: :unprocessable_entity }
        format.html { render :new, status: :unprocessable_entity }
      end
    end
  end

  def show
  end

  def destroy
    @calculation.destroy
    redirect_to settlement_calculations_path, notice: "Cálculo eliminado.", status: :see_other
  end

  def send_email
    email = params[:email].to_s.strip
    if email.match?(URI::MailTo::EMAIL_REGEXP)
      CalculationMailer.with(calculation: @calculation, to: email).settlement_result.deliver_later
      redirect_to @calculation, notice: "Resultado enviado a #{email}."
    else
      redirect_to @calculation, alert: "Correo electrónico inválido."
    end
  end

  private

  def set_calculation
    @calculation = SettlementCalculation.find(params[:id])
  end

  def calculation_params
    params.require(:settlement_calculation).permit(
      :worker_name, :monthly_salary, :start_date, :end_date, :termination_reason,
      :region, :vacation_days_taken, :fondos_reserva_paid, :legal_case_id
    )
  end
end
