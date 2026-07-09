class LegalCasesController < ApplicationController
  before_action :set_legal_case, only: %i[show edit update destroy purge_document]

  def index
    @legal_cases = LegalCase.includes(:client, :user).search(params[:q])
    @legal_cases = @legal_cases.where(case_type: params[:case_type]) if params[:case_type].present?
    @legal_cases = @legal_cases.where(status: params[:status]) if params[:status].present?
    @legal_cases = @legal_cases.order(updated_at: :desc)
  end

  def show
    @case_note = CaseNote.new
  end

  def new
    @legal_case = LegalCase.new(case_type: params[:case_type], client_id: params[:client_id])
  end

  def create
    @legal_case = LegalCase.new(legal_case_params)
    @legal_case.user = Current.user
    if @legal_case.save
      redirect_to @legal_case, notice: "Caso creado correctamente."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @legal_case.update(legal_case_params)
      redirect_to @legal_case, notice: "Caso actualizado correctamente."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @legal_case.destroy
    redirect_to legal_cases_path, notice: "Caso eliminado.", status: :see_other
  end

  def purge_document
    document = @legal_case.documents.find(params[:document_id])
    document.purge
    redirect_to @legal_case, notice: "Documento eliminado.", status: :see_other
  end

  private

  def set_legal_case
    @legal_case = LegalCase.find(params[:id])
  end

  def legal_case_params
    permitted = params.require(:legal_case).permit(
      :client_id, :case_type, :status, :title, :case_number, :court, :description, documents: []
    )
    # Avoid replacing existing attachments when no new files are selected
    permitted.delete(:documents) if permitted[:documents].blank? || permitted[:documents].all?(&:blank?)
    permitted
  end
end
