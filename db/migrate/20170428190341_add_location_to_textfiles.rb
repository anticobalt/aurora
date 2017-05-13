class AddLocationToTextfiles < ActiveRecord::Migration[5.0]
  def change
    add_column :textfiles, :location, :string
  end
end
