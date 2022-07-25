class WebhooksController < ApplicationController
  skip_before_action :verify_authenticity_token

  def create
    payload = request.body.read
    signature_header = request.env['HTTP_STRIPE_SIGNATURE']
    endpoint_secret = Rails.application.credentials.dig(:stripe, :webhook_signing_secret)

    event = nil

    begin
      event = Stripe::Webhook.construct_event(
        payload, signature_header, endpoint_secret
      )
    rescue JSON::ParserError => e
      render json: {message: e}, status: 400
      return
    rescue Stripe::SignatureVerificationError => e
      render json: {message: e}, status: 400
      return
    end

    case event.type
    when 'checkout.session.completed'

      return if !User.exists?(event.data.object.client_reference_id)

      fullfill_order(event.data.object)
    when 'invoice.payment.succeeded'
      reutrn unless event.data.object.subscription.present?

      stripe_subscription = Stripe::Subscription.retrieve(event.data.object.subscription)
      premium_subscription = Subscription.find_by(subscription_id: stripe_subscription)

      premium_subscription.update(
        current_period_start: Time.at(stripe_subscription.current_period_start).to_datetime,
        current_period_end: Time.at(stripe_subscription.current_period_end).to_datetime,
        plan: stripe_subscription.plan.id,
        interval: stripe_subscription.plan.interval,
        status: stripe_subscription.status
      )
    when 'invoice.payment_failed'
      user = User.find_by(stripe_id: event.data.object.customer)

      if user.exists?
        PremiumSubscriptionMailer.with(user: user).payment_failed.deliver_now
      end

    when 'customer.subscription.update'
      stripe_subscription = event.data.object

      if stripe_subscription.cancel_at_period_end == true
        premium_subscription = Subscription.find_by(subscription_id: stripe_subscription)

        if premium_subscription.present?
            premium_subscription.update(
              current_period_start: Time.at(stripe_subscription.current_period_start).to_datetime,
              current_period_end: Time.at(stripe_subscription.current_period_end).to_datetime,
              plan: stripe_subscription.plan.id,
              interval: stripe_subscription.plan.interval,
              status: stripe_subscription.status
            )
        end
      end
    else
     puts "Unhadled event type: #{event.type}"
    end
  end

  private


  def fullfill_order(checkout_session)
    # Find user and assign customer id from Stripe
    user = User.find(checkout_session.client_reference_id)
    user.update(stripe_id: checkout_session.customer)

    # retriever new subscription via stripe api

    stripe_subscription = Stripe::Subscription.retrieve(checkout_session.subscription)

    PremiumSubscription.create(
      customer_id: stripe_subscription.customer,
      current_period_start: Time.at(stripe_subscription.current_period_start).to_datetime,
      current_period_end: Time.at(stripe_subscription.current_period_end).to_datetime,
      plan: stripe_subscription.plan.id,
      interval: stripe_subscription.plan.interval,
      status: stripe_subscription.status,
      subscription_id: stripe_subscription.id,
      user: user
    )
  end
end
