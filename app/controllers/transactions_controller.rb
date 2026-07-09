class TransactionsController < ApplicationController
  before_action :set_transaction, only: [:edit, :update, :destroy]

  def index
    @transactions = current_user.transactions.includes(:category, :client).order(date: :desc)
    @month = params[:month].present? ? Date.parse(params[:month]) : Date.current
  end

  def new
    @transaction = current_user.transactions.build
    @categories = current_user.categories
    @clients = current_user.clients
  end

  def create
    @transaction = current_user.transactions.build(transaction_params)
    if @transaction.save
      redirect_to transactions_path, notice: "Transacción creada"
    else
      @categories = current_user.categories
      @clients = current_user.clients
      render :new
    end
  end

  def edit
    @categories = current_user.categories
    @clients = current_user.clients
  end

  def update
    if @transaction.update(transaction_params)
      redirect_to transactions_path, notice: "Transacción actualizada"
    else
      @categories = current_user.categories
      @clients = current_user.clients
      render :edit
    end
  end

  def destroy
    @transaction.destroy
    redirect_to transactions_path, notice: "Transacción eliminada"
  end

  private

  def set_transaction
    @transaction = current_user.transactions.find(params[:id])
  end

  def transaction_params
    params.require(:transaction).permit(:description, :amount, :date, :kind, :category_id, :client_id)
  end
end
