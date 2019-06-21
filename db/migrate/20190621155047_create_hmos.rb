class CreateHmos < ActiveRecord::Migration[5.2]
  def change
    create_table :hmos, id: :uuid do |t|
      t.string :name
      t.text :address
      t.string :contact_person
      t.string :contact_num

      t.timestamps
    end

    add_index :hmos, :name
  end
end
