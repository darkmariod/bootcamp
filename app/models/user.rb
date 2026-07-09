class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :categories, dependent: :destroy
  has_many :clients, dependent: :destroy
  has_many :transactions, dependent: :destroy
  has_many :invoices, dependent: :destroy
  has_many :weekly_budgets, dependent: :destroy
  has_many :subscriptions, dependent: :destroy

  # Every new account starts with the standard categories from the Excel model
  # so the user does not have to create them by hand.
  after_create :seed_default_categories

  # Default categories grouped exactly like the sections of the source Excel.
  DEFAULT_CATEGORIES = {
    ingreso_fijo: ["Sueldo", "Freelance"],
    egreso_necesario: ["Alquiler", "Servicios (luz, agua)", "Teléfono e Internet"],
    egreso: ["Comida", "Transporte", "Salud Mental", "Netflix", "Spotify", "Clases"],
    egreso_compra: ["Ropa", "Tecnología", "Libros", "Casa"],
    otro_egreso: ["Perros", "Videojuegos", "Música", "Cine"],
    egreso_viaje: ["Vuelos", "Hospedaje", "Tours y Actividades"]
  }.freeze

  private

  def seed_default_categories
    DEFAULT_CATEGORIES.each do |group, names|
      names.each do |name|
        categories.create!(name: name, group: group)
      end
    end
  end
end
