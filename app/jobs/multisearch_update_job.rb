class MultisearchUpdateJob < ApplicationJob
  queue_as :default

  def perform
    PgSearch::Multisearch.rebuild(Submission)
    PgSearch::Multisearch.rebuild(Community)
    PgSearch::Multisearch.rebuild(Comment)
  end
end
