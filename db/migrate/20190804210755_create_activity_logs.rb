class CreateActivityLogs < ActiveRecord::Migration[5.2]
  def change
    create_table :activity_logs, id: :uuid do |t|
      t.uuid :user_id
      t.string :action
      t.string :object_name
      t.uuid :object_id
      t.string :notes

      t.timestamps
    end

    add_index :activity_logs, :user_id
  end
end
