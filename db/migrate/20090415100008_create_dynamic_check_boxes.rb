class CreateDynamicCheckBoxes < ActiveRecord::Migration
  def self.up
    create_table :dynamic_check_boxes do |t|
      t.timestamps
      t.boolean :combine_option_groups
      t.string :missing_value_error
    end
  end

  def self.down
    drop_table :dynamic_check_boxes
  end
end
