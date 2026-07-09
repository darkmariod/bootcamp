class ClientsController < ApplicationController
  before_action :set_client, only: [:show, :edit, :update, :destroy]

  def index
    @clients = current_user.clients.includes(:invoices, :transactions).order(created_at: :desc)
  end

  def show
    @invoices = @client.invoices.order(created_at: :desc)
    @transactions = @client.transactions.order(created_at: :desc)
  end

  def new
    @client = current_user.clients.build
  end

  def create
    @client = current_user.clients.build(client_params)
    if @client.save
      redirect_to clients_path, notice: "Cliente creado"
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @client.update(client_params)
      redirect_to clients_path, notice: "Cliente actualizado"
    else
      render :edit
    end
  end

  def destroy
    @client.destroy
    redirect_to clients_path, notice: "Cliente eliminado"
  end

  private

  def set_client
    @client = current_user.clients.find(params[:id])
  end

  def client_params
    params.require(:client).permit(:name, :email, :phone)
  end
end
