class CaseNotesController < ApplicationController
  before_action :set_legal_case

  def create
    @case_note = @legal_case.case_notes.build(case_note_params)
    @case_note.user = Current.user

    respond_to do |format|
      if @case_note.save
        format.turbo_stream
        format.html { redirect_to @legal_case, notice: "Actuación registrada." }
      else
        format.html { redirect_to @legal_case, alert: "La actuación no puede estar vacía." }
        format.turbo_stream { head :unprocessable_entity }
      end
    end
  end

  def destroy
    @case_note = @legal_case.case_notes.find(params[:id])
    @case_note.destroy

    respond_to do |format|
      format.turbo_stream
      format.html { redirect_to @legal_case, notice: "Actuación eliminada.", status: :see_other }
    end
  end

  private

  def set_legal_case
    @legal_case = LegalCase.find(params[:legal_case_id])
  end

  def case_note_params
    params.require(:case_note).permit(:body)
  end
end
