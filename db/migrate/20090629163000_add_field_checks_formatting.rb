class AddFieldChecksFormatting < ActiveRecord::Migration
  def self.up
    add_column(:dynamic_field_checks, :format_match, :string)
    add_column(:dynamic_field_checks, :format_replace, :string)
  end

  def self.down
    remove_column(:dynamic_field_checks, :format_replace)
    remove_column(:dynamic_field_checks, :format_match)
  end
end