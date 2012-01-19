class CreatePhoneLookups < ActiveRecord::Migration
  def self.up
    create_table :phone_lookups do |t|
      t.timestamps
      t.string :phone_number, :limit => 10
      t.string :lookup_type
      t.datetime :lookup_performed_at
      t.string :status_description, :status_nbr, :abi_number, :address, :cell_phone, :city, :company_name, :contact_title_code, :country, :date_added, :dwelling_type, :employee_size, :estimated_head_of_household_income, :exchange_code, :fax_phone_number, :first_name, :full_name, :hq_branch_code, :head_of_household_birth_year, :head_of_household_gender, :homeowner_probability, :last_name, :length_of_residency, :local_sales_code, :middle_name, :name_prefix, :name_suffix, :original_phone, :public_company_indicator, :record_type, :run_type, :sic, :sic_description, :secondary_sic1, :secondary_sic2, :secondary_sic3, :secondary_sic4, :state_dnc, :state_or_province, :sub_parent_number, :ticker_symbol, :time_zone, :total_employee_size, :ultimate_parent_number, :zip_or_postal_code
    end
    add_index :phone_lookups, [:phone_number, :lookup_type], :unique => true
    add_index :phone_lookups, :phone_number
    add_index :phone_lookups, :lookup_type
  end

  def self.down
    drop_table :phone_lookups
  end
end
