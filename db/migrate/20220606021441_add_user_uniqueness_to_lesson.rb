class AddUserUniquenessToLesson < ActiveRecord::Migration[6.1]
  def change
    add_index :lessons, [:user_id, :gym_class_id], unique: true
  end
end
