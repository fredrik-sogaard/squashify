class CreateSpots < ActiveRecord::Migration
  def change
    create_table :spots do |t|
      t.references :game
      t.references :player
      t.integer :score
      t.timestamps null: false
    end
  end
end
