class ChangeProformaStatusDefault < ActiveRecord::Migration[8.1]
  def change
    change_column_default :proformas, :status, from: nil, to: 0
    Proforma.where(status: nil).update_all(status: 0)
  end
end
