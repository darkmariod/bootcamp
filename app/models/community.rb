class Community < ApplicationRecord
  extend FriendlyId
  include PgSearch::Model
  multisearchable against: [:title, :name]
  belongs_to :user
  has_many :submissions

  has_many :subscriptions
  has_many :users, through: :subscriptions
  validates_associated :submissions

 friendly_id :slug_candidates, use: [:slugged, :finders]

  def slug_candidates
    [:title, [:title, :name]]
  end

  def should_generate_new_friendly_id?
    if !slug?
      title_changed?
    else
      false
    end
  end
end
