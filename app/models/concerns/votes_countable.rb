require "active_support/concern"

module VotesCountable
  extend ActiveSupport::Concern

  included do
    def total_vote_count
      (get_upvotes.size - get_downvotes.size).to_s
    end
  end
end
