class AddFieldStep < ActiveRecord::Migration
  def self.up
    add_column(:dynamic_forms, :use_multistep, :boolean, :null => false, :default => false)

    add_column(:dynamic_fields, :step, :integer, :null => false, :default => 1)
    add_index(:dynamic_fields, :step)
  end

  def self.down
    remove_column(:dynamic_forms, :use_multistep)
    remove_column(:dynamic_fields, :step)
  end
end
