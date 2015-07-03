class CreateLeaveRequests < ActiveRecord::Migration
  def change
    create_table :leave_requests do |t|
      t.integer :type
      t.integer :status
      t.datetime :start_at
      t.datetime :end_at
      t.integer :user_id

      t.timestamps null: false
    end
  end
end
