class CreateTextfiles < ActiveRecord::Migration[5.0]
  def change
    create_table :textfiles do |t|
      t.string :name
      t.text :contents

      t.timestamps
    end
  end
end
