class AddDoctorIdToPatients < ActiveRecord::Migration[5.2]
  def change
    add_column :patients, :doctor_id, :uuid
    add_column :patients, :hospital_id, :uuid

    add_index :patients, :doctor_id
    add_index :patients, :hospital_id
  end
end
