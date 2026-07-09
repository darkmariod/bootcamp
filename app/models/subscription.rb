class Subscription < ApplicationRecord
  belongs_to :user
  belongs_to :category, optional: true

  validates :name, presence: true
  validates :amount, presence: true, numericality: { greater_than: 0 }
  validates :frequency, inclusion: { in: %w[weekly monthly] }
  validates :billing_day, presence: true, numericality: { in: 1..31 }, if: :monthly?
  validates :day_of_week, numericality: { in: 0..6 }, allow_nil: true

  scope :auto_creatable, -> { where(auto_create: true) }
  scope :weekly, -> { where(frequency: "weekly") }
  scope :monthly, -> { where(frequency: "monthly") }

  def monthly?
    frequency == "monthly"
  end

  def weekly?
    frequency == "weekly"
  end

  # Build a transaction from this subscription (does NOT save)
  def build_transaction
    user.transactions.build(
      description: name,
      amount: amount,
      date: scheduled_date,
      kind: :gasto_personal,
      category: category
    )
  end

  # The date this subscription applies to (for creating transactions)
  def scheduled_date
    if weekly?
      return Date.current if day_of_week.nil?

      days_until = (day_of_week - Date.current.wday) % 7
      Date.current + days_until
    else
      return Date.current if billing_day.nil?

      today = Date.current
      Date.new(today.year, today.month, [billing_day, Time.days_in_month(today.month, today.year)].min)
    end
  end

  # Check if this subscription needs a new transaction created
  def needs_creation?
    return false unless auto_create
    return true if last_created_at.nil?

    if monthly?
      last_created_at < scheduled_date.beginning_of_month
    elsif weekly?
      last_created_at < scheduled_date.beginning_of_week
    end
  end

  # Create transaction if needed, returns the tx or nil
  def create_pending_transaction!
    return nil unless needs_creation?

    tx = build_transaction
    tx.save!
    update!(last_created_at: Time.current)
    tx
  end
end
