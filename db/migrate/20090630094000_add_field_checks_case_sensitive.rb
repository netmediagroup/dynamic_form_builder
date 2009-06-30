class AddFieldChecksCaseSensitive < ActiveRecord::Migration
  def self.up
    add_column(:dynamic_field_checks, :case_sensitive, :boolean, :null => false, :default => true)
  end

  def self.down
    remove_column(:dynamic_field_checks, :case_sensitive)
  end
end