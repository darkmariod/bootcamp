class InvoicesController < ApplicationController
  before_action :set_invoice, only: [:edit, :update, :destroy]

  def index
    @invoices = current_user.invoices.includes(:client).order(created_at: :desc)
  end

  def new
    @invoice = current_user.invoices.build
    @clients = current_user.clients
  end

  def create
    @invoice = current_user.invoices.build(invoice_params)
    if @invoice.save
      redirect_to invoices_path, notice: "Factura creada"
    else
      @clients = current_user.clients
      render :new
    end
  end

  def edit
    @clients = current_user.clients
  end

  def update
    if @invoice.update(invoice_params)
      redirect_to invoices_path, notice: "Factura actualizada"
    else
      @clients = current_user.clients
      render :edit
    end
  end

  def destroy
    @invoice.destroy
    redirect_to invoices_path, notice: "Factura eliminada"
  end

  private

  def set_invoice
    @invoice = current_user.invoices.find(params[:id])
  end

  def invoice_params
    params.require(:invoice).permit(:name, :amount, :description, :issue_date, :status, :client_id)
  end
end
