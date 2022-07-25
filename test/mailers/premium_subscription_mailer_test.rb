require "test_helper"

class PremiumSubscriptionMailerTest < ActionMailer::TestCase
  test "payment_failed" do
    mail = PremiumSubscriptionMailer.payment_failed
    assert_equal "Payment failed", mail.subject
    assert_equal ["to@example.org"], mail.to
    assert_equal ["from@example.com"], mail.from
    assert_match "Hi", mail.body.encoded
  end

end
