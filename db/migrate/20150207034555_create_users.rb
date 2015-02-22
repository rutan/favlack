class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :uid, limit: 32
      t.string :name, limit: 64
      t.string :avatar_url

      t.timestamps null: false
    end
    add_index :users, [:uid], unique: true
    add_index :users, [:name]
  end
end
