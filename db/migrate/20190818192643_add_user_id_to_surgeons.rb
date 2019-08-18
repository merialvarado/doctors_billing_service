class AddUserIdToSurgeons < ActiveRecord::Migration[5.2]
  def change
    add_column :surgeons, :doctor_id, :uuid
    add_column :procedure_types, :doctor_id, :uuid

    add_index :surgeons, :doctor_id
    add_index :procedure_types, :doctor_id
  end
end
