u = User.find_by(email: "demo@finanzas.com")

# Reset all subscription auto-create timestamps to force fresh creation
u.subscriptions.update_all(last_created_at: nil)

# Delete transactions that match subscription names (they'll be re-created)
sub_names = u.subscriptions.pluck(:name)
deleted = u.transactions.where(description: sub_names).destroy_all.count
puts "Deleted #{deleted} subscription transactions"

# Now re-run the rake task via system
puts "Ready for transactions:auto_create"
