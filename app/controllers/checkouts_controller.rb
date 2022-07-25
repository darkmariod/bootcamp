class CheckoutsController < ApplicationController
  before_action :authenticate_user!

  def create
    Stripe.api_key = Rails.application.credentials.dig(:stripe, :private_key)

    session = Stripe::Checkout::Session.create(
      customer: current_user.stripe_id,
      client_reference_id: current_user.id,
      success_url: root_url + "success?session_id={CHECKOUT_SESSION_ID}",
      cancel_url: pricing_url,
      payment_method_types: ['card'],
      mode: 'subscription',
      customer_email: current_user.email,
      line_items: [{
        quantity: 1,
        price: Rails.application.credentials.dig(:stripe, :price_id)
      }]
    )

    redirect_to session.url, allow_other_host: true
  end

  def success
    session = Stripe::Checkout::Session.retrieve(params[:session_id])
    @customer = Stripe::Customer.retrieve(session.customer)
  end

  def destroy
  end
end
