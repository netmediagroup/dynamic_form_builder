class CreateDynamicArrays < ActiveRecord::Migration
  def self.up
    create_table :dynamic_arrays do |t|
      t.timestamps
      t.string :name
    end
  end

  def self.down
    drop_table :dynamic_arrays
  end
end
