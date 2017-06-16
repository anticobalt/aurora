class AddArchivedToTextfiles < ActiveRecord::Migration[5.0]
  def change
    add_column :textfiles, :archived, :boolean
  end
end
