require 'rails_helper'

RSpec.describe Restaurant, type: :model do
  subject {
    described_class.new(name: "Burger King")
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
      menu = Menu.create(name: "Lunch", restaurant_id: subject.id)
    end

    it "is has many menus" do
      expect(subject.menus.count).to be(1)
    end
  end
end
