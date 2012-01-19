require 'soap/wsdlDriver'
class StrikeIron
  # The constants USER_ID and PASSWORD must be provided in your own script StrikeIronConnect.
  include StrikeIronConnect

  # WSDL_PREFIX = 'http://ws.strikeiron.com/'
  WSDL_PREFIX = 'http://wsparam.strikeiron.com/'

  def self.validate_and_normalize_phone(phone)
    phone.gsub!(/\D/,'')
    phone.match(/^\d{10}$/).nil? ? nil : phone
  end

  def self.normalize_result_value(value)
    value unless value.class == SOAP::Mapping::Object
  end

end
