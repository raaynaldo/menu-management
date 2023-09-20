class MenuItem < ApplicationRecord
  belongs_to :restaurant
  has_and_belongs_to_many :menus

  validates :name, presence: true
  validates_uniqueness_of :name, case_sensitive: false, scope: [:restaurant_id, :price], message: ->(object, data) do
                                   ": #{object.name}, price: #{object.price}, and restaurant_id: #{object.restaurant_id} combination must be unique"
                                 end
  validates :price, presence: true, numericality: { greater_than: 0 }
  validate :menus_are_same_restaurant

  private

  def menus_are_same_restaurant
    unless menus.all? { |menu| menu.restaurant_id == restaurant_id }
      errors.add(:base, "All menus must belong to the same restaurant as the menu item.")
    end
  end
end
