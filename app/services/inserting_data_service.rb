class InsertingDataService
  def import(json)
    menu_item_log = { success: [], fail: [] }
    ActiveRecord::Base.transaction do
      for restaurant in json["restaurants"]
        new_res = Restaurant.create(name: restaurant["name"])
        if !new_res.valid?
          puts "\n#{restaurant["name"]} restaurant is not valid"
          puts new_res.errors.full_messages
          next
        end

        for menu in restaurant["menus"]
          new_menu = Menu.create(name: menu["name"], restaurant_id: new_res.id)
          if !new_menu.valid?
            puts "\n#{restaurant["name"]} => #{new_menu["name"]}  menu is not valid"
            puts new_menu.errors.full_messages
            next
          end

          menu_items = menu["menu_items"] != nil ? menu["menu_items"] : menu["dishes"]
          for menu_item in menu_items
            new_menu_item = MenuItem.create({ "name": menu_item["name"], "price": menu_item["price"], restaurant_id: new_res.id })
            if !new_menu_item.valid?
              menu_item_log[:fail] << menu_item
              puts "\n#{restaurant["name"]} => #{new_menu["name"]} => #{new_menu_item["name"]} menu_item is not valid"
              puts new_menu_item.errors.full_messages
              next
            end
            menu_item_log[:success] << menu_item

            new_menu.menu_items << new_menu_item
          end
        end
      end
    end

    return menu_item_log
  rescue ActiveRecord::RecordInvalid => e
    # Handle validation errors
    puts "Record is invalid: #{e.message}"
  end
end
