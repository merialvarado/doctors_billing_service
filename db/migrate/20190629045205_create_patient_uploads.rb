class CreatePatientUploads < ActiveRecord::Migration[5.2]
  def change
    create_table :patient_uploads, id: :uuid do |t|
      t.string :state
      t.uuid :uploaded_by_id
      t.string :csv_file

      t.timestamps
    end

    add_index :patient_uploads, :uploaded_by_id
  end
end
