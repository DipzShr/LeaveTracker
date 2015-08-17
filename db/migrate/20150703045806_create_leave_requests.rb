class CreateLeaveRequests < ActiveRecord::Migration
  def change
    create_table :leave_requests do |t|
      t.string :leave_type
      t.string :status
      t.datetime :leave_date
      t.string :duration
      t.integer :user_id

      t.timestamps null: false
    end
  end
end
