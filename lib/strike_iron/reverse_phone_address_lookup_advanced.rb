require 'soap/header/simplehandler'
class StrikeIron::ReversePhoneAddressLookupAdvanced
  include StrikeIron::ReversePhoneAddressLookupCommon

  WSDL = "http://ws.strikeiron.com/PhoneandAddressAdvanced?WSDL"

  class WsseAuthHeader < SOAP::Header::SimpleHandler
    def initialize
      super(XSD::QName.new('http://ws.strikeiron.com', 'LicenseInfo'))
    end

    def on_simple_outbound
      {"RegisteredUser" => {"UserID" => self.class.parent.parent::USER_ID, "Password" => self.class.parent.parent::PASSWORD}}
    end
  end

  def initialize(phone)
    @phone = self.class.parent.validate_and_normalize_phone(phone)
  end

  def result
    if @result.nil? && @phone.present?
      driver = SOAP::WSDLDriverFactory.new(self.class::WSDL).create_rpc_driver
      # driver.wiredump_dev = STDOUT
      driver.headerhandler << WsseAuthHeader.new

      @result = driver.reverseLookupByPhoneNumber({'PhoneNumber' => @phone})
    end
    @result
  end

  def attributes
    attrs = {}
    (methods - Object.methods - ['attributes','result']).each do |m|
      attrs[m.to_sym] = self.send(m)
    end
    attrs
  end

  # These methods aren't listed in the Common module.

  def city
    self.class.parent.normalize_result_value(result.reverseLookupByPhoneNumberResult.serviceResult.city) if result && result.reverseLookupByPhoneNumberResult.serviceResult.methods.include?('city')
  end

  def run_type
    self.class.parent.normalize_result_value(result.reverseLookupByPhoneNumberResult.serviceResult.runType) if result && result.reverseLookupByPhoneNumberResult.serviceResult.methods.include?('runType')
  end

end
