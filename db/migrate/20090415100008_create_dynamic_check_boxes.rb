class CreateDynamicCheckBoxes < ActiveRecord::Migration
  def self.up
    create_table :dynamic_check_boxes do |t|
      t.timestamps
      t.boolean :default_checked
      t.string :input_label, :input_value
    end
  end

  def self.down
    drop_table :dynamic_check_boxes
  end
end
