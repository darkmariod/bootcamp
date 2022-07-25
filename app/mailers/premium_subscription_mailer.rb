class PremiumSubscriptionMailer < ApplicationMailer

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.premium_subscription_mailer.payment_failed.subject
  #
  def payment_failed
    @user = params[:user]

    mail to: @user.email, subject: "Webbit Premium Payment Attempt Failed"
  end
end
