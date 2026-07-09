class User < ApplicationRecord
  has_secure_password
  has_many :sessions, dependent: :destroy
  has_many :legal_cases, dependent: :nullify
  has_many :case_notes, dependent: :nullify
  has_many :alimony_calculations, dependent: :destroy
  has_many :settlement_calculations, dependent: :destroy

  normalizes :email_address, with: ->(e) { e.strip.downcase }

  ROLES = { "admin" => "Administrador", "abogado" => "Abogado" }.freeze

  validates :name, presence: true
  validates :role, inclusion: { in: ROLES.keys }, allow_blank: true

  def admin? = role == "admin"
  def role_label = ROLES[role] || "Abogado"

  def display_name
    name.presence || email_address
  end
end
