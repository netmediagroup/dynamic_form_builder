class CreateDynamicFieldFormats < ActiveRecord::Migration
  def self.up
    create_table :dynamic_field_formats do |t|
      t.timestamps
      t.integer :dynamic_field_id
      t.string :format_when
      t.integer :sort, :null => false, :default => 0
      t.string :match, :replace
    end
    add_index :dynamic_field_formats, :dynamic_field_id
    add_index :dynamic_field_formats, :format_when
    add_index :dynamic_field_formats, :sort
  end

  def self.down
    drop_table :dynamic_field_formats
  end
end
