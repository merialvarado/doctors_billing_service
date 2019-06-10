class CreatePatients < ActiveRecord::Migration[5.2]
  def change
    create_table :patients, id: :uuid do |t|
      t.string :first_name
      t.string :middle_name
      t.string :surname
      t.string :patient_num
      t.date :date_admitted
      t.string :procedure
      t.string :hmo
      t.string :contact_num

      t.timestamps
    end
  end
end
