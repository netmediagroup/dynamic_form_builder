class CreateDynamicFieldableDefaultArrayItems < ActiveRecord::Migration
  def self.up
    create_table :dynamic_fieldable_default_array_items do |t|
      t.timestamps
      t.string :defaultable_type
      t.integer :defaultable_id, :dynamic_array_item_id
    end
    add_index :dynamic_fieldable_default_array_items, [:defaultable_type, :defaultable_id], :name => 'index_dfdai_on_defaultable'
    add_index :dynamic_fieldable_default_array_items, :dynamic_array_item_id, :name => 'index_dfdai_on_daii'
  end

  def self.down
    drop_table :dynamic_fieldable_default_array_items
  end
end
