class AddEmbeddedIdToTextfiles < ActiveRecord::Migration[5.0]
  def change
    add_column :textfiles, :embedded_id, :integer
  end
end
