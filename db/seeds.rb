# Idempotent seed: creates a demo account you can log in with right away.
# New users automatically get the default categories via a User callback,
# so we only need to create the account here.

demo = User.find_or_initialize_by(email: "demo@finanzas.com")
if demo.new_record?
  demo.password = "password123"
  demo.password_confirmation = "password123"
  demo.weekly_limit = 20
  demo.save!
  puts "✅ Cuenta demo creada: demo@finanzas.com / password123"
  puts "   Categorías cargadas automáticamente: #{demo.categories.count}"
else
  puts "ℹ️  La cuenta demo ya existe: demo@finanzas.com"
end
