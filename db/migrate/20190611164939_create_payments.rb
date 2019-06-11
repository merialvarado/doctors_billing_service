class CreatePayments < ActiveRecord::Migration[5.2]
  def change
    create_table :payments, id: :uuid do |t|
      t.uuid :patient_id
      t.decimal :amount, precision: 17, scale: 2, default: 0.0
      t.string :check_num
      t.date :check_date
      t.string :bank

      t.timestamps
    end

    add_index :payments, :patient_id
  end
end
