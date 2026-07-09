class DashboardController < ApplicationController
  def index
    @cases_count = LegalCase.count
    @open_cases_count = LegalCase.where.not(status: :archivado).count
    @clients_count = Client.count
    @calculations_count = AlimonyCalculation.count + SettlementCalculation.count
    @recent_cases = LegalCase.includes(:client).order(updated_at: :desc).limit(6)
    @cases_by_type = LegalCase.group(:case_type).count.transform_keys { |k| LegalCase::CASE_TYPE_LABELS[k] }
    @recent_notes = CaseNote.includes(:legal_case, :user).order(created_at: :desc).limit(5)
  end
end
