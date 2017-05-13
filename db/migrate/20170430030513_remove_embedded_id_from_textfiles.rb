class RemoveEmbeddedIdFromTextfiles < ActiveRecord::Migration[5.0]
  def change
    remove_column :textfiles, :embedded_id, :integer
  end
end
