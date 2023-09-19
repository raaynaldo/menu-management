require "rails_helper"

RSpec.describe MenuItem, type: :model do
  subject {
    restaurant = Restaurant.create(name: "Burger King")
    menu = Menu.create(name: "lunch", restaurant_id: restaurant.id)
    described_class.new(name: "Burger", price: 9, menu_id: menu.id)
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
  end
end
