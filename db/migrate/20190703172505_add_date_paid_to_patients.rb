class AddDatePaidToPatients < ActiveRecord::Migration[5.2]
  def change
    add_column :patients, :date_paid, :date
    add_column :patients, :procedure_date, :date
  end
end
