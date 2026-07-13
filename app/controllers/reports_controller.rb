class ReportsController < ApplicationController
  def index
    @desde = parse_date(params[:desde]) || Date.current.beginning_of_month
    @hasta = parse_date(params[:hasta]) || Date.current.end_of_month
    @kind = params[:kind].presence
    @client_id = params[:client_id].presence

    scope = current_user.transactions
                        .where(date: @desde..@hasta)
                        .includes(:category, :client)
    scope = scope.where(kind: @kind) if @kind && Transaction.kinds.key?(@kind)
    scope = scope.where(client_id: @client_id) if @client_id

    @transactions = scope.order(date: :desc)

    @total_ingresos = @transactions.select(&:ingreso?).sum(&:amount)
    @total_egresos  = @transactions.reject(&:ingreso?).sum(&:amount)
    @count = @transactions.size

    # Egresos agrupados por categoría, para el gráfico de barras.
    @por_categoria = @transactions
                     .reject(&:ingreso?)
                     .group_by { |t| t.category&.name || "Sin categoría" }
                     .transform_values { |ts| ts.sum(&:amount) }
                     .sort_by { |_name, total| -total }

    @clients = current_user.clients.order(:name)
  end

  private

  def parse_date(value)
    Date.parse(value) if value.present?
  rescue ArgumentError
    nil
  end
end
