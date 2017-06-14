class AddTextfileDisplayModeToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :textfile_display_mode, :string
  end
end
