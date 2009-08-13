class CreateDynamicRadioButtons < ActiveRecord::Migration
  def self.up
    create_table :dynamic_radio_buttons do |t|
      t.timestamps
      t.integer :default_item_id
      t.boolean :combine_option_groups
      t.string :missing_value_error
    end
  end

  def self.down
    drop_table :dynamic_radio_buttons
  end
end
