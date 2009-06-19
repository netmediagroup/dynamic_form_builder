class CreateDynamicArrayItems < ActiveRecord::Migration
  def self.up
    create_table :dynamic_array_items do |t|
      t.timestamps
      t.integer :dynamic_array_id, :null => false
      t.integer :sort, :null => false, :default => 0
      t.string :item_display, :item_value
    end
    add_index :dynamic_array_items, :dynamic_array_id
    add_index :dynamic_array_items, :sort
  end

  def self.down
    drop_table :dynamic_array_items
  end
end
