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
      subject.save()
      menu_item = MenuItem.create(name: "Burger", price: 2, menu_id: subject.id)
    end

    it "is has many items" do
      expect(subject.menu_items.count).to be(1)
    end
  end
end
