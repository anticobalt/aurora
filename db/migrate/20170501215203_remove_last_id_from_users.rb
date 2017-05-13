class RemoveLastIdFromUsers < ActiveRecord::Migration[5.0]
  def change
    remove_column :users, :last_id, :integer
  end
end
