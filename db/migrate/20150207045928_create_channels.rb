class CreateChannels < ActiveRecord::Migration
  def change
    create_table :channels do |t|
      t.string :uid, limit: 32
      t.string :name, limit: 64

      t.timestamps null: false
    end
    add_index :channels, [:uid], unique: true
    add_index :channels, [:name]
  end
end
