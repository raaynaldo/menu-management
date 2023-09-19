class MenuItem < ApplicationRecord
  belongs_to :restaurant
  has_and_belongs_to_many :menus

  validates :name, presence: true, uniqueness: { case_sensitive: false, scope: :restaurant_id }
  validates :price, presence: true, numericality: { greater_than: 0 }
  validate :menus_are_same_restaurant
  
  private

  def menus_are_same_restaurant
    unless menus.all? { |menu| menu.restaurant_id == restaurant_id}
      errors.add(:base, "All menus must belong to the same restaurant as the menu item.")
    end
  end
end
