class AddTagCategoriesToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :tag_categories, :text
  end
end
