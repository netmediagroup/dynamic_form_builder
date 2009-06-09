class CreateDynamicTextAreas < ActiveRecord::Migration
  def self.up
    create_table :dynamic_text_areas do |t|
      t.timestamps
      t.integer :rows, :columns
      t.string :prompt, :wordwrapping
    end
  end

  def self.down
    drop_table :dynamic_text_areas
  end
end
