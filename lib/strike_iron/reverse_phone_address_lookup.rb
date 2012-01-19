class StrikeIron::ReversePhoneAddressLookup
  include StrikeIron::ReversePhoneAddressLookupCommon

  WSDL = "#{parent::WSDL_PREFIX}ReversePhoneAddressLookup?WSDL"

  def initialize(phone)
    @phone = self.class.parent.validate_and_normalize_phone(phone)
  end

  def result
    if @result.nil?
      unless @phone.nil?
        driver = SOAP::WSDLDriverFactory.new(self.class::WSDL).create_rpc_driver
        @result = driver.reverseLookupByPhoneNumber({'UserID' => self.class.parent::USER_ID, 'Password' => self.class.parent::PASSWORD, 'PhoneNumber' => @phone})
      end
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

  # This field returns the name of the company.
  def company_name
    self.class.parent.normalize_result_value(result.reverseLookupByPhoneNumberResult.serviceResult.companyName) if result && result.reverseLookupByPhoneNumberResult.serviceResult.methods.include?('companyName')
  end

  # This field returns the name prefix. (DR., REV., MR, MRS.)
  def name_prefix
    self.class.parent.normalize_result_value(result.reverseLookupByPhoneNumberResult.serviceResult.namePrefix) if result && result.reverseLookupByPhoneNumberResult.serviceResult.methods.include?('namePrefix')
  end

end
