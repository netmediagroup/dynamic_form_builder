class CreateDynamicFieldChecks < ActiveRecord::Migration
  def self.up
    create_table :dynamic_field_checks do |t|
      t.timestamps
      t.integer :dynamic_field_id
      t.string :check_for, :check_type, :check_value, :custom_message
    end
    add_index :dynamic_field_checks, :dynamic_field_id
    add_index :dynamic_field_checks, :check_for
  end

  def self.down
    drop_table :dynamic_field_checks
  end
end
