class SubscriptionsController < ApplicationController
  before_action :set_categories, only: [:index]

  def index
    @subscriptions = current_user.subscriptions.order(:name)
    @total = @subscriptions.sum(:amount)
    @monthly_spent = current_user.transactions
      .where(kind: :gasto_personal)
      .where(date: Date.current.beginning_of_month..Date.current.end_of_month)
      .sum(:amount)
    @monthly_limit = current_user.monthly_limit || current_user.weekly_limit.to_f * 4.33
  end

  def create
    @subscription = current_user.subscriptions.build(subscription_params)
    if @subscription.save
      redirect_to subscriptions_path, notice: "Suscripción agregada"
    else
      redirect_to subscriptions_path, alert: @subscription.errors.full_messages.to_sentence
    end
  end

  def update
    @subscription = current_user.subscriptions.find(params[:id])
    if @subscription.update(subscription_params)
      redirect_to subscriptions_path, notice: "Suscripción actualizada"
    else
      redirect_to subscriptions_path, alert: @subscription.errors.full_messages.to_sentence
    end
  end

  def destroy
    @subscription = current_user.subscriptions.find(params[:id])
    @subscription.destroy
    redirect_to subscriptions_path, notice: "Suscripción eliminada"
  end

  # Crea las transacciones pendientes de todas las suscripciones con auto_create
  def create_pending
    created = 0
    current_user.subscriptions.auto_creatable.each do |sub|
      tx = sub.create_pending_transaction!
      created += 1 if tx
    end

    if created > 0
      redirect_to subscriptions_path, notice: "#{created} transacción #{'creada'.pluralize(created)}"
    else
      redirect_to subscriptions_path, notice: "Sin transacciones pendientes"
    end
  end

  private

  def set_categories
    @categories = current_user.categories.where(group: :egreso).order(:name)
  end

  def subscription_params
    params.require(:subscription).permit(:name, :amount, :billing_day, :frequency,
                                         :day_of_week, :category_id, :auto_create)
  end
end
