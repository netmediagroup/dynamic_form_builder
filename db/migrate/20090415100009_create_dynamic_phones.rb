class CreateDynamicPhones < ActiveRecord::Migration
  def self.up
    create_table :dynamic_phones do |t|
      t.timestamps
      t.boolean :separate_inputs, :dividers
    end
  end

  def self.down
    drop_table :dynamic_phones
  end
end
