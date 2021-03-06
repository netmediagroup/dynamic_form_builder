class CreateDynamicSelects < ActiveRecord::Migration
  def self.up
    create_table :dynamic_selects do |t|
      t.timestamps
      t.integer :default_item_id
      t.boolean :combine_option_groups, :default => true
      t.boolean :allow_blank
      t.string :prompt, :missing_value_error
    end
  end

  def self.down
    drop_table :dynamic_selects
  end
end
