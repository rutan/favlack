class AddPermalinkToMessages < ActiveRecord::Migration
  def change
    add_column :messages, :permalink, :string
  end
end
