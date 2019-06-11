class AddBillingAmountToPatient < ActiveRecord::Migration[5.2]
  def change
  	add_column :patients, :billing_amount, :decimal, precision: 17, scale: 2, default: 0.0
  	add_column :patients, :payment_status, :string
  	add_column :patients, :balance, :decimal, precision: 17, scale: 2, default: 0.0
  end
end
