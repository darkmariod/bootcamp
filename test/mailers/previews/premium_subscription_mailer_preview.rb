# Preview all emails at http://localhost:3000/rails/mailers/premium_subscription_mailer
class PremiumSubscriptionMailerPreview < ActionMailer::Preview

  # Preview this email at http://localhost:3000/rails/mailers/premium_subscription_mailer/payment_failed
  def payment_failed
    PremiumSubscriptionMailer.with(user: User.first).payment_failed
  end

end
