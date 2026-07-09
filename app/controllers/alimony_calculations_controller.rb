class AlimonyCalculationsController < ApplicationController
  before_action :set_calculation, only: %i[show destroy send_email]

  def index
    @calculations = AlimonyCalculation.includes(:user, :legal_case).order(created_at: :desc)
  end

  def new
    @calculation = AlimonyCalculation.new(
      children_under_3: 0, children_3_plus: 1, disability_range: :none, iess_deducted: false
    )
  end

  def create
    @calculation = AlimonyCalculation.new(calculation_params)
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
    redirect_to alimony_calculations_path, notice: "Cálculo eliminado.", status: :see_other
  end

  def send_email
    email = params[:email].to_s.strip
    if email.match?(URI::MailTo::EMAIL_REGEXP)
      CalculationMailer.with(calculation: @calculation, to: email).alimony_result.deliver_later
      redirect_to @calculation, notice: "Resultado enviado a #{email}."
    else
      redirect_to @calculation, alert: "Correo electrónico inválido."
    end
  end

  private

  def set_calculation
    @calculation = AlimonyCalculation.find(params[:id])
  end

  def calculation_params
    params.require(:alimony_calculation).permit(
      :applicant_name, :monthly_income, :iess_deducted, :children_under_3,
      :children_3_plus, :claimed_children, :disability_range, :legal_case_id
    )
  end
end
