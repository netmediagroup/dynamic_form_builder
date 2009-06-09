class CreateDynamicArrayGroups < ActiveRecord::Migration
  def self.up
    create_table :dynamic_array_groups do |t|
      t.timestamps
      t.string :name, :label, :dynamic_arrayable_type
      t.integer :dynamic_arrayable_id, :dynamic_array_id, :sort, :null => false
    end
    add_index :dynamic_array_groups, [:dynamic_arrayable_type, :dynamic_arrayable_id], :name => 'index_fag_on_dynamic_arrayable'
    add_index :dynamic_array_groups, :dynamic_array_id
    add_index :dynamic_array_groups, :sort
  end

  def self.down
    drop_table :dynamic_array_groups
  end
end
