class CreatePlayers < ActiveRecord::Migration
  def change

    create_table :players do |t|
      t.string :name
      t.string :email
      t.string :password_hash
      t.string :password_salt
      t.timestamps null: false
    end

  end
end
