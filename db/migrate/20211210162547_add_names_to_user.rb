class AddNamesToUser < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :fname, :string, default: "Unknown"
    add_column :users, :lname, :string, default: "Unknown"
  end
end
