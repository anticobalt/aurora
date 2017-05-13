class CreateUsers < ActiveRecord::Migration[5.0]
  def change
    create_table :users do |t|
      t.integer :last_id
      t.string :home

      t.timestamps
    end
  end
end
