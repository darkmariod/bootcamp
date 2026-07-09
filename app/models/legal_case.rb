class LegalCase < ApplicationRecord
  belongs_to :client
  belongs_to :user
  has_many :case_notes, -> { order(created_at: :desc) }, dependent: :destroy
  has_many :alimony_calculations, dependent: :nullify
  has_many :settlement_calculations, dependent: :nullify
  has_many_attached :documents

  enum :case_type, { transito: 0, penal: 1, alimentos: 2, laboral: 3, civil: 4 }
  enum :status, { abierto: 0, en_tramite: 1, audiencia: 2, sentencia: 3, archivado: 4 }

  validates :title, presence: true
  validates :case_type, presence: true
  validates :status, presence: true

  CASE_TYPE_LABELS = {
    "transito" => "Tránsito", "penal" => "Penal", "alimentos" => "Pensión Alimenticia",
    "laboral" => "Laboral", "civil" => "Civil"
  }.freeze

  STATUS_LABELS = {
    "abierto" => "Abierto", "en_tramite" => "En trámite", "audiencia" => "Audiencia",
    "sentencia" => "Sentencia", "archivado" => "Archivado"
  }.freeze

  def case_type_label = CASE_TYPE_LABELS[case_type]
  def status_label = STATUS_LABELS[status]

  def self.search(term)
    return all if term.blank?

    joins(:client).where(
      "legal_cases.title ILIKE :t OR legal_cases.case_number ILIKE :t OR clients.name ILIKE :t",
      t: "%#{sanitize_sql_like(term)}%"
    )
  end
end
