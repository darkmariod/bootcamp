class CalculationMailer < ApplicationMailer
  def alimony_result
    @calculation = params[:calculation]
    mail(to: params[:to], subject: "LawyerEC — Cálculo de pensión alimenticia (#{@calculation.applicant_name})")
  end

  def settlement_result
    @calculation = params[:calculation]
    mail(to: params[:to], subject: "LawyerEC — Cálculo de liquidación laboral (#{@calculation.worker_name})")
  end
end
