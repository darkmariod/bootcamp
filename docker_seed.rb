u = User.find_or_initialize_by(email: "demo@finanzas.com")
if u.new_record?
  u.password = "password123"
  u.password_confirmation = "password123"
  u.weekly_limit = 50
  u.monthly_limit = 200
  u.save!
  puts "Demo user created with weekly_limit=50, monthly_limit=200"
  puts "  Categories: #{u.categories.count}"
else
  u.update!(weekly_limit: 50, monthly_limit: 200)
  puts "Demo user updated: weekly_limit=50, monthly_limit=200"
end

unless u.categories.exists?(name: "Clases")
  u.categories.create!(name: "Clases", group: :egreso)
  puts "Categoria Clases agregada"
end

comida = u.categories.find_by(name: "Comida")
clases = u.categories.find_by(name: "Clases")

unless u.subscriptions.exists?(name: "Encebollado")
  u.subscriptions.create!(name: "Encebollado", amount: 5, frequency: "weekly", day_of_week: 0, category: comida, auto_create: true)
  puts "Encebollado (semanal, domingo)"
end

unless u.subscriptions.exists?(name: "Clases de cocina")
  u.subscriptions.create!(name: "Clases de cocina", amount: 25, frequency: "monthly", billing_day: 1, category: clases, auto_create: true)
  puts "Clases de cocina (mensual, dia 1)"
end
