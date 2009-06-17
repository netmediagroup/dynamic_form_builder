class CreateDynamicFields < ActiveRecord::Migration
  def self.up
    create_table :dynamic_fields do |t|
      t.timestamps
      t.integer :dynamic_form_id, :null => false
      t.boolean :active, :default => false
      t.integer :sort, :null => false, :default => 0
      t.string :fieldable_type
      t.integer :fieldable_id
      t.boolean :required, :null => false, :default => true
      t.boolean :check_duplication, :null => false, :default => false
      t.string :column_name, :label, :column_type, :required_error
    end
    add_index :dynamic_fields, :dynamic_form_id
    add_index :dynamic_fields, :active
    add_index :dynamic_fields, :sort
    add_index :dynamic_fields, :check_duplication
    add_index :dynamic_fields, [:fieldable_type, :fieldable_id], :name => 'index_df_on_fieldable'
  end

  def self.down
    drop_table :dynamic_fields
  end
end
