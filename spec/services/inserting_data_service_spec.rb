require "rails_helper"
require "json"

RSpec.describe InsertingDataService, type: :model do
  describe "#import" do
    let(:data) do
      data = File.open("restaurant_data.json")
      JSON.load(data)
    end

    before do
      @log = InsertingDataService.new.import(data)
      data["restaurants"][1]["menus"][0]["dishes"].delete_at(2)
    end

    it "returns successful and failed menu item log" do
      expect(@log[:success].count).to eq(8)
      expect(@log[:fail].count).to eq(1)
    end

    it "creates restaurants, menus, and menu items" do
      restaurant_names = []
      menus_names = []
      menu_item_names = []
      menu_item_prices = []
      data["restaurants"].each do |restaurant|
        restaurant_names << restaurant["name"]

        restaurant["menus"].each do |menu|
          menus_names << menu["name"]

          menu_items = menu["menu_items"] ? menu["menu_items"] : menu["dishes"]
          menu_items.each do |menu_item|
            menu_item_names << menu_item["name"]
            menu_item_prices << menu_item["price"]
          end
        end
      end

      expect(Restaurant.where(name: restaurant_names).count).to eq(2)

      expect(Menu.where(name: menus_names.uniq).count).to eq(4)

      expect(MenuItem.where(name: menu_item_names, price: menu_item_prices).count).to eq(8)
    end

    it "associates menus and menu items with the correct restaurants" do
      data["restaurants"].each_with_index do |restaurant_data, index|
        restaurant = Restaurant.find_by(name: restaurant_data["name"])

        expect(restaurant).not_to be_nil

        expect(restaurant.menus.count).to eq(restaurant_data["menus"].count)

        expect(restaurant.menus.sum { |menu| menu.menu_items.count }).to eq(restaurant_data["menus"].sum { |menu| menu["menu_items"] ? menu["menu_items"].count : menu["dishes"].count })
      end
    end
  end
end
