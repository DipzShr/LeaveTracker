class AddStatusAndSuperadminToUsers < ActiveRecord::Migration
  def change
    add_column :users, :status, :integer
    add_column :users, :superadmin, :boolean
  end
end
