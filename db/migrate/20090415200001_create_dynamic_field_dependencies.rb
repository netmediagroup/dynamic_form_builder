class CreateDynamicFieldDependencies < ActiveRecord::Migration
  def self.up
    create_table :dynamic_field_dependencies do |t|
      t.integer :child_id, :parent_id
      t.string :dependent_value
    end
    add_index :dynamic_field_dependencies, [:child_id, :parent_id], :unique => true, :name => 'index_df_dependencies'
  end

  def self.down
    drop_table :dynamic_field_dependencies
  end
end
