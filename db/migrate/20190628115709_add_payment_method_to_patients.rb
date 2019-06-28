class AddPaymentMethodToPatients < ActiveRecord::Migration[5.2]
  def change
    add_column :patients, :payment_method, :string
  end
end
