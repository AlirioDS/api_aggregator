class CreateUserStatuses < ActiveRecord::Migration[7.2]
  def change
    create_table :user_statuses do |t|
      t.string :full_name
      t.string :experience
      t.integer :pending_task_count
      t.string :next_urgent_task

      t.timestamps
    end
  end
end
