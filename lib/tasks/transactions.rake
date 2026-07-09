namespace :transactions do
  desc "Create pending transactions from auto-creatable subscriptions"
  task auto_create: :environment do
    total = 0
    User.includes(:subscriptions).each do |user|
      user.subscriptions.auto_creatable.each do |sub|
        tx = sub.create_pending_transaction!
        total += 1 if tx
      end
    end
    puts "Created #{total} transactions"
  end
end
