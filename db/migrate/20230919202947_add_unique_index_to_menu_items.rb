class AddUniqueIndexToMenuItems < ActiveRecord::Migration[7.0]
  def change
    add_index :menu_items, [:name, :restaurant], unique: true
  end
end
