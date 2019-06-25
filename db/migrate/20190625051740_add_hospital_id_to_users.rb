class AddHospitalIdToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :hospital_id, :uuid
    add_index :users, :hospital_id
  end
end
