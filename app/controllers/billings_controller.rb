class BillingsController < ApplicationController
  before_action :authenticate_user!

  def create
     Stripe.api_key = Rails.application.credentials.dig(:stripe, :private_key)
    session = Stripe::BillingPortal::Session.create({
      customer: current_user.stripe_id,
      return_url: root_url
    })

    redirect_to session.url, allow_other_host: true
  end
end
