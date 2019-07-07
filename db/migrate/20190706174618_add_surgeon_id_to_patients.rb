class AddSurgeonIdToPatients < ActiveRecord::Migration[5.2]
  def change
    add_column :patients, :surgeon_id, :uuid
    add_column :patients, :procedure_type_id, :uuid
    add_index :patients, :surgeon_id
    add_index :patients, :procedure_type_id

    remove_column :patients, :surgeon
    remove_column :patients, :procedure
  end
end
