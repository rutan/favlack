class CreateMessages < ActiveRecord::Migration
  def change
    create_table :messages do |t|
      t.references :user, index: true
      t.references :channel, index: true
      t.string :ts
      t.text :body

      t.timestamps null: false
    end
    add_foreign_key :messages, :users
    add_foreign_key :messages, :channels
    add_index :messages, [:channel_id, :ts], unique: true
  end
end
