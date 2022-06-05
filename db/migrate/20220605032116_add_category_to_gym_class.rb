class AddCategoryToGymClass < ActiveRecord::Migration[6.1]
  def change
    add_reference :gym_classes, :category, null: false, foreign_key: true
  end
end
