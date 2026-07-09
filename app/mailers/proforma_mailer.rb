class ProformaMailer < ApplicationMailer
  def proforma_email
    @proforma = params[:proforma]
    mail(to: params[:to], subject: "LawyerEC — Proforma de honorarios #{@proforma.number}")
  end
end
