class CreateHospitals < ActiveRecord::Migration[5.2]
  def change
    create_table :hospitals, id: :uuid do |t|
      t.string :name
      t.string :contact_num
      t.string :address

      t.timestamps
    end
  end
end
