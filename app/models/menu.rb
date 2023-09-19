class Menu < ApplicationRecord
  belongs_to :restaurant
  has_and_belongs_to_many :menu_items

  validates :name, presence: true
  validate :menu_items_are_same_restaurant

  private

  def menu_items_are_same_restaurant
    unless menu_items.all? { |menu_item| menu_item.restaurant_id == restaurant_id}
      errors.add(:base, "All menu items must belong to the same restaurant as the menu.")
    end
  end
end
