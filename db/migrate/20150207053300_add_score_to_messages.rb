class AddScoreToMessages < ActiveRecord::Migration
  def change
    add_column :messages, :score, :integer, default: 0
    add_index :messages, [:score]
  end
end
