class AddFilenameToUsers < ActiveRecord::Migration
  def change
    add_column :users, :filename, :string
  end
end
