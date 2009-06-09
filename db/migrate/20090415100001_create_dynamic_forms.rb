class CreateDynamicForms < ActiveRecord::Migration
  def self.up
    create_table :dynamic_forms do |t|
      t.timestamps
      t.boolean :active, :default => false
      t.string :name
      t.integer :duplication_days
    end
    add_index :dynamic_forms, :active
  end

  def self.down
    drop_table :dynamic_forms
  end
end
