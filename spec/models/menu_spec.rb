require "rails_helper"

RSpec.describe Menu, type: :model do
  subject {
    restaurant = Restaurant.create(name: "Burger King")
    described_class.new(name: "Lunch", restaurant_id: restaurant.id)
  }

  describe "validation" do
    it "is invalid if name is not present" do
      subject.name = nil
      expect(subject).to_not be_valid
    end

    it "is valid if name is present" do
      expect(subject).to be_valid
    end
  end

  describe "association" do
    before do
      menu_item = MenuItem.create(name: "Burger", price: 2, restaurant_id: subject.restaurant.id)
      subject.menu_items << menu_item
      subject.save()
    end

    it "is has many menu items" do
      expect(subject.menu_items.count).to be(1)
    end

    it "is not valid if the menu item belongs to different Restaurant" do
      restaurant2 = Restaurant.create(name: "McDonald")
      menu_item = MenuItem.create(name: "Whooper", price: 3, restaurant_id: restaurant2.id)
      subject.menu_items << menu_item
      expect { subject.save!() }.to raise_error(ActiveRecord::RecordInvalid)
    end
  end
end
