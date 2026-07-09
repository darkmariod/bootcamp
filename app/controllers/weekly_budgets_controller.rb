class WeeklyBudgetsController < ApplicationController
  # Shows the monthly budget overview (subscriptions + monthly spend) plus
  # the current week's budget details and history.
  def show
    @budgets = WeeklyBudget.sync_for(current_user).reverse
    @current = @budgets.find { |b| b.week_start == Date.current.beginning_of_week }

    @subscriptions = current_user.subscriptions.order(:name)
    @subscriptions_total = @subscriptions.sum(:amount)
    @monthly_limit = current_user.monthly_limit || current_user.weekly_limit.to_f * 4.33
    @monthly_spent = current_user.transactions
      .where(kind: :gasto_personal)
      .where(date: Date.current.beginning_of_month..Date.current.end_of_month)
      .sum(:amount)
  end

  # Updates the base weekly spending limit (e.g. 20 USD).
  def update
    if current_user.update(budget_params)
      WeeklyBudget.sync_for(current_user)
      redirect_to weekly_budget_path, notice: "Límite semanal actualizado"
    else
      @budgets = WeeklyBudget.sync_for(current_user).reverse
      @current = @budgets.find { |b| b.week_start == Date.current.beginning_of_week }
      render :show, status: :unprocessable_entity
    end
  end

  private

  def budget_params
    params.require(:user).permit(:weekly_limit, :monthly_limit)
  end
end
