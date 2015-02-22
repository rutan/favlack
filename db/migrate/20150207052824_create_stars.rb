class CreateStars < ActiveRecord::Migration
  def change
    create_table :stars do |t|
      t.references :user, index: true
      t.references :message, index: true

      t.timestamps null: false
    end
    add_foreign_key :stars, :users
    add_foreign_key :stars, :messages
    add_index :stars, [:user_id, :message_id], unique: true
  end
end
