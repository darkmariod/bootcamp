class DashboardController < ApplicationController
  def index
    @user = current_user
    @budget = WeeklyBudget.current_for(current_user)
  end
end
