class AlterHmoFromPatients < ActiveRecord::Migration[5.2]
  def change
  	remove_column :patients, :hmo
  	add_column :patients, :hmo_id, :uuid
  	add_index :patients, :hmo_id
  end
end
