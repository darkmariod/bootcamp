class WeeklyBudget < ApplicationRecord
  belongs_to :user

  validates :week_start, presence: true, uniqueness: { scope: :user_id }

  # Amount actually spent on personal life expenses during this week.
  # Computed live from transactions so it stays accurate as the user adds data.
  def spent
    user.transactions
        .where(kind: :gasto_personal)
        .where(date: week_start..week_start.end_of_week)
        .sum(:amount)
  end

  # Total available = the base weekly limit + whatever rolled over from prior weeks.
  def available
    limit_amount + carried_over
  end

  # What's left to spend this week (can be negative if the user overspent).
  def remaining
    available - spent
  end

  # Only a positive remaining rolls forward to the next week.
  def surplus
    [remaining, 0].max
  end

  def overspent?
    remaining.negative?
  end

  # Rebuilds/updates the weekly budget rows for a user, from the week they
  # signed up up to the current week, propagating the surplus (rollover)
  # forward week by week. Idempotent: safe to call on every page load.
  def self.sync_for(user)
    limit = user.weekly_limit || 0
    return [] if limit <= 0

    # Anchor at the earliest relevant date: whichever comes first between the
    # account creation and the first recorded transaction. This ensures a
    # backdated expense still starts the rollover chain from its real week.
    first_tx_date = user.transactions.minimum(:date)
    anchor_date = [user.created_at.to_date, first_tx_date].compact.min
    anchor = anchor_date.beginning_of_week
    current = Date.current.beginning_of_week

    carried = 0.to_d
    week = anchor
    budgets = []

    while week <= current
      budget = user.weekly_budgets.find_or_initialize_by(week_start: week)
      budget.limit_amount = limit
      budget.carried_over = carried
      budget.save!
      budgets << budget

      # The surplus of this week becomes next week's carry-over.
      carried = budget.surplus
      week += 7
    end

    budgets
  end

  def self.current_for(user)
    sync_for(user)
    user.weekly_budgets.find_by(week_start: Date.current.beginning_of_week)
  end
end
