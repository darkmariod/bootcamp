class ProformasController < ApplicationController
  before_action :set_proforma, only: %i[show edit update destroy send_email update_status]

  def index
    @proformas = Proforma.includes(:client, :user).search(params[:q])
    @proformas = @proformas.where(status: params[:status]) if params[:status].present?
    @proformas = @proformas.order(created_at: :desc)
  end

  def show
  end

  def new
    @proforma = Proforma.new(issued_on: Date.current, valid_until: 30.days.from_now.to_date,
                             client_id: params[:client_id], legal_case_id: params[:legal_case_id])
    build_blank_items
  end

  def create
    @proforma = Proforma.new(proforma_params)
    @proforma.user = Current.user
    if @proforma.save
      redirect_to @proforma, notice: "Proforma #{@proforma.number} creada correctamente."
    else
      build_blank_items
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    build_blank_items
  end

  def update
    if @proforma.update(proforma_params)
      redirect_to @proforma, notice: "Proforma actualizada correctamente."
    else
      build_blank_items
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @proforma.destroy
    redirect_to proformas_path, notice: "Proforma eliminada.", status: :see_other
  end

  def send_email
    email = params[:email].presence || @proforma.client.email
    if email.to_s.match?(URI::MailTo::EMAIL_REGEXP)
      ProformaMailer.with(proforma: @proforma, to: email).proforma_email.deliver_later
      @proforma.enviada! if @proforma.borrador?
      redirect_to @proforma, notice: "Proforma enviada a #{email}."
    else
      redirect_to @proforma, alert: "El cliente no tiene correo registrado. Ingrese uno válido."
    end
  end

  def update_status
    if Proforma.statuses.key?(params[:status])
      @proforma.update!(status: params[:status])
      redirect_to @proforma, notice: "Proforma marcada como #{@proforma.status_label.downcase}."
    else
      redirect_to @proforma, alert: "Estado inválido."
    end
  end

  private

  def set_proforma
    @proforma = Proforma.find(params[:id])
  end

  def build_blank_items
    (3 - @proforma.proforma_items.reject(&:marked_for_destruction?).size).clamp(1, 3).times { @proforma.proforma_items.build(quantity: 1) }
  end

  def proforma_params
    params.require(:proforma).permit(
      :client_id, :legal_case_id, :issued_on, :valid_until, :notes, :status,
      proforma_items_attributes: %i[id description quantity unit_price _destroy]
    )
  end
end
