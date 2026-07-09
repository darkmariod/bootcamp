# Minimal seed data for LawyerEC

puts "Seeding..."

User.find_or_create_by!(email_address: "admin@lawyerec.com") do |u|
  u.name = "Admin de Prueba"
  u.password = "demo123456"
  u.role = "admin"
end

client = Client.find_or_create_by!(cedula: "0601234567") do |c|
  c.name = "Cliente de Prueba"
  c.email = "cliente@example.com"
  c.phone = "0991234567"
  c.address = "Riobamba, Ecuador"
end

LegalCase.find_or_create_by!(case_number: "06332-2026-00001") do |lc|
  lc.client = client
  lc.user = User.find_by!(email_address: "admin@lawyerec.com")
  lc.case_type = :transito
  lc.status = :abierto
  lc.title = "Caso de prueba — impugnación de citación de tránsito"
  lc.court = "Unidad Judicial de Tránsito de Riobamba"
  lc.description = "Registro de ejemplo para explorar el sistema."
end

puts "Done. Usuario: admin@lawyerec.com / demo123456"
