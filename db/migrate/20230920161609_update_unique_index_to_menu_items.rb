class UpdateUniqueIndexToMenuItems < ActiveRecord::Migration[7.0]
  def change
    remove_index :menu_items, name: "index_menu_items_on_name_and_restaurant" if index_exists?(:menu_items, :name, name: "index_menu_items_on_name_and_restaurant")
    add_index :menu_items, [:name, :restaurant_id, :price], unique: true
  end
end
