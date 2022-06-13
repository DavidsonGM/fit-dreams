class AllowNilCategoryInGymClass < ActiveRecord::Migration[6.1]
  def change
    change_column_null :gym_classes, :category_id, true
  end
end
