class CreateGymClasses < ActiveRecord::Migration[6.1]
  def change
    create_table :gym_classes do |t|
      t.string :name
      t.time :start_time
      t.integer :duration
      t.text :description
      t.references :teacher, index: true, foreign_key: { to_table: :users }

      t.timestamps
    end
  end
end
