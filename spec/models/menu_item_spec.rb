require "rails_helper"

RSpec.describe MenuItem, type: :model do
  subject {
    restaurant = Restaurant.create(name: "Burger King")
    described_class.new(name: "Burger", price: 9, restaurant_id: restaurant.id)
  }

  describe "validation" do
    it "is invalid if name is not present" do
      subject.name = ""
      expect(subject).to_not be_valid
    end

    it "is valid if name is present" do
      expect(subject).to be_valid
    end

    it "is invalid if price is not present" do
      subject.price = nil
      expect(subject).to_not be_valid
    end

    it "is invalid if price is 0" do
      subject.price = 0
      expect(subject).to_not be_valid
    end

    it "is valid if price is present" do
      expect(subject).to be_valid
    end

    it "is invalid if name is already exist in the same restaurant" do
      subject.save()
      menu_item = described_class.new(name: "Burger", price: 5, restaurant_id: subject.restaurant_id)
      expect(menu_item).to_not be_valid
    end

    it "is valid if name is already exist in the different restaurant" do
      subject.save()
      restaurant = Restaurant.create(name: "McDonald")
      menu_item = described_class.new(name: "Burger", price: 5, restaurant_id: restaurant.id)
      expect(menu_item).to be_valid
    end
  end

  describe "association" do
    before do
      menu = Menu.create(name: "lunch", restaurant_id: subject.restaurant.id)
      subject.menus << menu
      subject.save()
    end

    it "is has many menus" do
      expect(subject.menus.count).to be(1)
    end

    it "is not valid if the menu belongs to different Restaurant" do
      restaurant = Restaurant.create(name: "McDonald")
      menu = Menu.create(name: "Dinner", restaurant_id: restaurant.id)
      subject.menus << menu
      expect { subject.save!() }.to raise_error(ActiveRecord::RecordInvalid)
    end

  end
end
