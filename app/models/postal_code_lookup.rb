class PostalCodeLookup < ActiveRecord::Base
  establish_connection :lookups
  set_table_name 'postal_codes'

  def self.matches?(code)
    find(:first, :conditions => {:code => code}).nil? ? false : true
  end

end
