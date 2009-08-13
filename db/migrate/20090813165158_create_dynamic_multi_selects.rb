class CreateDynamicMultiSelects < ActiveRecord::Migration
  def self.up
    create_table :dynamic_multi_selects do |t|
      t.timestamps
      t.integer :size
      t.boolean :combine_option_groups, :default => true
      t.boolean :allow_blank
      t.string :prompt, :missing_value_error
    end
  end

  def self.down
    drop_table :dynamic_multi_selects
  end
end
