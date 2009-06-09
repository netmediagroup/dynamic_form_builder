class CreateDynamicTextFields < ActiveRecord::Migration
  def self.up
    create_table :dynamic_text_fields do |t|
      t.timestamps
      t.integer :maxlength, :size
      t.string :prompt
    end
  end

  def self.down
    drop_table :dynamic_text_fields
  end
end
