class CreateSurgeons < ActiveRecord::Migration[5.2]
  def change
    create_table :surgeons, id: :uuid do |t|
      t.string :full_name

      t.timestamps
    end
  end
end
