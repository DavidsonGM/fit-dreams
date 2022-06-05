class CreateLessons < ActiveRecord::Migration[6.1]
  def change
    create_table :lessons do |t|
      t.references :user, null: false, foreign_key: true
      t.references :gym_class, null: false, foreign_key: true

      t.timestamps
    end
  end
end
