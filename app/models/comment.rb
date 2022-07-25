class Comment < ApplicationRecord
  include PgSearch::Model
  include VotesCountable

  multisearchable against: :reply

  belongs_to :submission
  belongs_to :user

  validates :reply, presence: true

  acts_as_votable
end
