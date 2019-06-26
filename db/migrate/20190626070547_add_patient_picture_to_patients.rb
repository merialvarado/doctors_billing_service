class AddPatientPictureToPatients < ActiveRecord::Migration[5.2]
  def change
    add_column :patients, :patient_picture, :string
    add_column :patients, :surgeon, :string
    add_column :patients, :remarks, :text
    add_column :patients, :state, :string
  end
end
