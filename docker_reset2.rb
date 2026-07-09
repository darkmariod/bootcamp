u = User.find_by(email: "demo@finanzas.com")
u.subscriptions.where(auto_create: false).destroy_all
u.subscriptions.update_all(last_created_at: nil)
u.transactions.where(description: u.subscriptions.pluck(:name)).destroy_all
puts "Cleaned. Users subs: #{u.subscriptions.count}"
