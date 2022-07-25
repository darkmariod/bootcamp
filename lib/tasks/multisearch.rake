namespace :multisearch do
  task update: :environment do
    MultisearchUpdateJob.perform_later
  end
end
