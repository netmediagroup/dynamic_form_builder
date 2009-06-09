class CreateDynamicHiddenFields < ActiveRecord::Migration
  def self.up
    create_table :dynamic_hidden_fields do |t|
      t.timestamps
      t.string :default_value
    end
  end

  def self.down
    drop_table :dynamic_hidden_fields
  end
end
