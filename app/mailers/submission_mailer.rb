class SubmissionMailer < ApplicationMailer
  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.submission_mailer.new_response.subject
  #
  def new_response
    @submission = params[:submission]
    @comment = params[:comment]

    mail to: @submission.user.email, subject: "New reponse on #{@submission.title} via webbit"
  end
end
