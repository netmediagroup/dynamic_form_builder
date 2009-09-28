require 'soap/wsdlDriver'
class StrikeIron
  # WSDL_PREFIX = 'http://ws.strikeiron.com/'
  WSDL_PREFIX = 'http://wsparam.strikeiron.com/'

  USER_ID = 'dfoy@affiliatecrew.com'
  PASSWORD = 'bulletbug'

  def self.validate_and_normalize_phone(phone)
    phone.gsub!(/\D/,'')
    phone.match(/^\d{10}$/).nil? ? nil : phone
  end

  def self.normalize_result_value(value)
    value unless value.class == SOAP::Mapping::Object
  end


  class ReversePhoneAddressLookup
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

    # This field returns the description of the status number.
    def status_description
      self.class.parent.normalize_result_value(result.reverseLookupByPhoneNumberResult.serviceStatus.statusDescription) if result && result.reverseLookupByPhoneNumberResult.serviceStatus.methods.include?('statusDescription')
    end

    # This field returns a number referring to the status of this request.
    def status_nbr
      self.class.parent.normalize_result_value(result.reverseLookupByPhoneNumberResult.serviceStatus.statusNbr) if result && result.reverseLookupByPhoneNumberResult.serviceStatus.methods.include?('statusNbr')
    end

    # This field returns an ABI Number which provides a unique identifier for each business in the infoUSA database.
    def abi_number
      self.class.parent.normalize_result_value(result.reverseLookupByPhoneNumberResult.serviceResult.aBINumber) if result && result.reverseLookupByPhoneNumberResult.serviceResult.methods.include?('aBINumber')
    end

    # This field returns the street address associated to the phone number provided.
    def address
      self.class.parent.normalize_result_value(result.reverseLookupByPhoneNumberResult.serviceResult.address) if result && result.reverseLookupByPhoneNumberResult.serviceResult.methods.include?('address')
    end

    # If the phone number provided as input is for a cell phone, the output returned for this field is true. Otherwise, the output returned for this field is false.
    # (values = T or F)
    def cell_phone
      self.class.parent.normalize_result_value(result.reverseLookupByPhoneNumberResult.serviceResult.cellPhone) if result && result.reverseLookupByPhoneNumberResult.serviceResult.methods.include?('cellPhone')
    end

    # This field returns the name of the company.
    def company_name
      self.class.parent.normalize_result_value(result.reverseLookupByPhoneNumberResult.serviceResult.companyName) if result && result.reverseLookupByPhoneNumberResult.serviceResult.methods.include?('companyName')
    end

    # This field returns a code corresponding to the title of the designated contact.
    #   1 Owner
    #   2 President
    #   3 Manager
    #   4 Executive Director
    #   5 Principal
    #   6 Publisher
    #   7 Administrator
    #   8 Religious Leader
    #   9 Partner
    #   A Chairman
    #   B Vice Chairman
    #   C Chief Executive Officer
    #   D Director (Public Co)
    #   E Chief Operating Officer (COO)
    #   F Chief Financial Officer (CFO)
    #   G Treasurer
    #   H Controller
    #   I Executive Vice President
    #   J Senior Vice President
    #   K Vice President
    #   L Administration Executive
    #   M Corporate Communications Executive
    #   N Data Processing Executive
    #   O Finance Executive
    #   P Human Resources Executive
    #   Q Telecommunication Executive
    #   R Marketing Executive
    #   S Operations Executive
    #   T Sales Executive
    #   U Corporate Secretary
    #   V General Counsel
    #   W Executive Officer
    #   X Plant Manager
    #   Y Purchasing Agent
    #   Z Auditor
    def contact_title_code
      self.class.parent.normalize_result_value(result.reverseLookupByPhoneNumberResult.serviceResult.contactTitleCode) if result && result.reverseLookupByPhoneNumberResult.serviceResult.methods.include?('contactTitleCode')
    end

    # This field returns the country.
    def country
      self.class.parent.normalize_result_value(result.reverseLookupByPhoneNumberResult.serviceResult.country) if result && result.reverseLookupByPhoneNumberResult.serviceResult.methods.include?('country')
    end

    # This field returns the date when this information was last updated.
    def date_added
      self.class.parent.normalize_result_value(result.reverseLookupByPhoneNumberResult.serviceResult.dateAdded) if result && result.reverseLookupByPhoneNumberResult.serviceResult.methods.include?('dateAdded')
    end

    # This field returns the dwelling type.
    # Dwellings types:
    #   C= Single Family
    #   D-K = 2-9 Residences at Same Address
    #   L= 10-19 Residences at Same Address
    #   M= 20-49 Residences at Same Address
    #   N= 50-100 Residences at Same Address
    #   O= 100+ Residences at Same Address
    def dwelling_type
      self.class.parent.normalize_result_value(result.reverseLookupByPhoneNumberResult.serviceResult.dwellingType) if result && result.reverseLookupByPhoneNumberResult.serviceResult.methods.include?('dwellingType')
    end

    # This field returns the number of employees at the location specified above.
    def employee_size
      self.class.parent.normalize_result_value(result.reverseLookupByPhoneNumberResult.serviceResult.employeeSize) if result && result.reverseLookupByPhoneNumberResult.serviceResult.methods.include?('employeeSize')
    end

    # This field returns the estimated household income, if available.
    def estimated_head_of_household_income
      self.class.parent.normalize_result_value(result.reverseLookupByPhoneNumberResult.serviceResult.estimatedHeadOfHouseholdIncome) if result && result.reverseLookupByPhoneNumberResult.serviceResult.methods.include?('estimatedHeadOfHouseholdIncome')
    end

    # This field returns the stock exchange that carries the stock symbol.
    def exchange_code
      self.class.parent.normalize_result_value(result.reverseLookupByPhoneNumberResult.serviceResult.exchangeCode) if result && result.reverseLookupByPhoneNumberResult.serviceResult.methods.include?('exchangeCode')
    end

    # This field returns the fax number for the company.
    def fax_phone_number
      self.class.parent.normalize_result_value(result.reverseLookupByPhoneNumberResult.serviceResult.faxPhoneNumber) if result && result.reverseLookupByPhoneNumberResult.serviceResult.methods.include?('faxPhoneNumber')
    end

    # This field returns the first name.
    def first_name
      self.class.parent.normalize_result_value(result.reverseLookupByPhoneNumberResult.serviceResult.firstName) if result && result.reverseLookupByPhoneNumberResult.serviceResult.methods.include?('firstName')
    end

    # This field returns the full name.
    def full_name
      self.class.parent.normalize_result_value(result.reverseLookupByPhoneNumberResult.serviceResult.fullName) if result && result.reverseLookupByPhoneNumberResult.serviceResult.methods.include?('fullName')
    end

    # This field indicates if this address represents a single location, headquarters or branch of the company.
    #   1 = Headquarters
    #   2 = Branches
    #   3 = Subsidiary Headquarters
    #   Blank = None of the above
    def hq_branch_code
      self.class.parent.normalize_result_value(result.reverseLookupByPhoneNumberResult.serviceResult.hQBranchCode) if result && result.reverseLookupByPhoneNumberResult.serviceResult.methods.include?('hQBranchCode')
    end

    # This field returns the year of birth of the head of the household, if available.
    def head_of_household_birth_year
      self.class.parent.normalize_result_value(result.reverseLookupByPhoneNumberResult.serviceResult.headOfHouseholdBirthYear) if result && result.reverseLookupByPhoneNumberResult.serviceResult.methods.include?('headOfHouseholdBirthYear')
    end

    # This field returns the gender of the head of the household.
    def head_of_household_gender
      self.class.parent.normalize_result_value(result.reverseLookupByPhoneNumberResult.serviceResult.headOfHouseholdGender) if result && result.reverseLookupByPhoneNumberResult.serviceResult.methods.include?('headOfHouseholdGender')
    end

    # This field returns the homeowner probability.
    # Types:
    #   H= Homeowner
    #   9= probable homeowner 90-100%
    #   8= probable homeowner 80-89%
    #   7= probable homeowner 70-79%
    #   6= Likely Homeowner
    #   R= Renter
    #   T, 0-4 = Probably Renter
    #   U, 5= Unknown
    def homeowner_probability
      self.class.parent.normalize_result_value(result.reverseLookupByPhoneNumberResult.serviceResult.homeownerProbability) if result && result.reverseLookupByPhoneNumberResult.serviceResult.methods.include?('homeownerProbability')
    end

    # This field returns the last name.
    def last_name
      self.class.parent.normalize_result_value(result.reverseLookupByPhoneNumberResult.serviceResult.lastName) if result && result.reverseLookupByPhoneNumberResult.serviceResult.methods.include?('lastName')
    end

    # This field returns the length of time the person has lived at the residence.
    def length_of_residency
      self.class.parent.normalize_result_value(result.reverseLookupByPhoneNumberResult.serviceResult.lengthOfResidency) if result && result.reverseLookupByPhoneNumberResult.serviceResult.methods.include?('lengthOfResidency')
    end

    # This field returns an alpha code corresponding to the estimated sales of the business in thousands of dollars.
    #   A 1 - 499
    #   B 500 - 999
    #   C 1,000 - 2,499
    #   D 2,500 - 4,999
    #   E 5,000 - 9,999
    #   F 10,000 - 19,999
    #   G 20,000 - 49,999
    #   H 50,000 - 99,999
    #   I 100,000 - 499,999
    #   J 500,000 - 999,999
    #   K 1,000,000 +
    def local_sales_code
      self.class.parent.normalize_result_value(result.reverseLookupByPhoneNumberResult.serviceResult.localSalesCode) if result && result.reverseLookupByPhoneNumberResult.serviceResult.methods.include?('localSalesCode')
    end

    # This field returns the middle name or initial.
    def middle_name
      self.class.parent.normalize_result_value(result.reverseLookupByPhoneNumberResult.serviceResult.middleName) if result && result.reverseLookupByPhoneNumberResult.serviceResult.methods.include?('middleName')
    end

    # This field returns the name prefix. (DR., REV., MR, MRS.)
    def name_prefix
      self.class.parent.normalize_result_value(result.reverseLookupByPhoneNumberResult.serviceResult.namePrefix) if result && result.reverseLookupByPhoneNumberResult.serviceResult.methods.include?('namePrefix')
    end

    # This field returns the name suffix (if applicable)
    def name_suffix
      self.class.parent.normalize_result_value(result.reverseLookupByPhoneNumberResult.serviceResult.nameSuffix) if result && result.reverseLookupByPhoneNumberResult.serviceResult.methods.include?('nameSuffix')
    end

    # This field returns the phone number provided as input.
    def original_phone
      self.class.parent.normalize_result_value(result.reverseLookupByPhoneNumberResult.serviceResult.originalPhone) if result && result.reverseLookupByPhoneNumberResult.serviceResult.methods.include?('originalPhone')
    end

    # This field returns whether or not the company is public, if available.
    def public_company_indicator
      self.class.parent.normalize_result_value(result.reverseLookupByPhoneNumberResult.serviceResult.publicCompanyIndicator) if result && result.reverseLookupByPhoneNumberResult.serviceResult.methods.include?('publicCompanyIndicator')
    end

    # Indicates if the number provided is a business or residential number. The demographic data returned will correspond to the record type.
    # Potential Values:
    #   IS or IP= Residential Match
    #   BS or BP= Business Match
    #   IC= Residential Canadian Match
    #   BC= Business Canadian Match
    def record_type
      self.class.parent.normalize_result_value(result.reverseLookupByPhoneNumberResult.serviceResult.recordType) if result && result.reverseLookupByPhoneNumberResult.serviceResult.methods.include?('recordType')
    end

    # Standard Industry Code for the Company.
    def sic
      self.class.parent.normalize_result_value(result.reverseLookupByPhoneNumberResult.serviceResult.sIC) if result && result.reverseLookupByPhoneNumberResult.serviceResult.methods.include?('sIC')
    end

    # Description of the Standard Industry Code for the Company.
    def sic_description
      self.class.parent.normalize_result_value(result.reverseLookupByPhoneNumberResult.serviceResult.sICDescription) if result && result.reverseLookupByPhoneNumberResult.serviceResult.methods.include?('sICDescription')
    end

    # This field returns any additional activity of the business.
    def secondary_sic1
      self.class.parent.normalize_result_value(result.reverseLookupByPhoneNumberResult.serviceResult.secondarySIC1) if result && result.reverseLookupByPhoneNumberResult.serviceResult.methods.include?('secondarySIC1')
    end

    # This field returns any additional activity of the business.
    def secondary_sic2
      self.class.parent.normalize_result_value(result.reverseLookupByPhoneNumberResult.serviceResult.secondarySIC2) if result && result.reverseLookupByPhoneNumberResult.serviceResult.methods.include?('secondarySIC2')
    end

    # This field returns any additional activity of the business.
    def secondary_sic3
      self.class.parent.normalize_result_value(result.reverseLookupByPhoneNumberResult.serviceResult.secondarySIC3) if result && result.reverseLookupByPhoneNumberResult.serviceResult.methods.include?('secondarySIC3')
    end

    # This field returns any additional activity of the business.
    def secondary_sic4
      self.class.parent.normalize_result_value(result.reverseLookupByPhoneNumberResult.serviceResult.secondarySIC4) if result && result.reverseLookupByPhoneNumberResult.serviceResult.methods.include?('secondarySIC4')
    end

    # This field returns a ‘Yes, ‘No’ or (blank) indicating whether or not the phone number is on the specific state or Direct Marketing Association Do Not Call list.
    # (*NOTE: this field does not return information from the National Do Not Call List.).
    def state_dnc
      self.class.parent.normalize_result_value(result.reverseLookupByPhoneNumberResult.serviceResult.stateDNC) if result && result.reverseLookupByPhoneNumberResult.serviceResult.methods.include?('stateDNC')
    end

    # This field returns the state or province.
    def state_or_province
      self.class.parent.normalize_result_value(result.reverseLookupByPhoneNumberResult.serviceResult.stateOrProvince) if result && result.reverseLookupByPhoneNumberResult.serviceResult.methods.include?('stateOrProvince')
    end

    # The subsidiary parent number identifies the business as a regional or subsidiary headquarters for the corporate family. The subsidiary will always have an ultimate parent and may or may not have braches assigned to it.
    def sub_parent_number
      self.class.parent.normalize_result_value(result.reverseLookupByPhoneNumberResult.serviceResult.subParentNumber) if result && result.reverseLookupByPhoneNumberResult.serviceResult.methods.include?('subParentNumber')
    end

    # This field returns the stock ticker symbol.
    def ticker_symbol
      self.class.parent.normalize_result_value(result.reverseLookupByPhoneNumberResult.serviceResult.tickerSymbol) if result && result.reverseLookupByPhoneNumberResult.serviceResult.methods.include?('tickerSymbol')
    end

    # This field returns the time zone.
    # Values:
    #   E= Eastern
    #   C= Central
    #   M= Mountain
    #   P= Pacific
    #   A= Alaska
    #   H= Hawaii
    def time_zone
      self.class.parent.normalize_result_value(result.reverseLookupByPhoneNumberResult.serviceResult.timeZone) if result && result.reverseLookupByPhoneNumberResult.serviceResult.methods.include?('timeZone')
    end

    # This field returns the number of employees in the company.
    def total_employee_size
      self.class.parent.normalize_result_value(result.reverseLookupByPhoneNumberResult.serviceResult.totalEmployeeSize) if result && result.reverseLookupByPhoneNumberResult.serviceResult.methods.include?('totalEmployeeSize')
    end

    # The ultimate parent number identifies the corporate parent of the business and also serves as the ABI number for the headquarters site of the ultimate parent. Since all locations if a business have the same ultimate parent number, this field provides ‘corporate ownership’ linkage information. This information is not collected or maintained for the types of organizations for which ownership is ambiguous- churches, and schools in particular, are not linked in the file for this reason.
    def ultimate_parent_number
      self.class.parent.normalize_result_value(result.reverseLookupByPhoneNumberResult.serviceResult.ultimateParentNumber) if result && result.reverseLookupByPhoneNumberResult.serviceResult.methods.include?('ultimateParentNumber')
    end

    # This field returns the ZIP or postal code.
    def zip_or_postal_code
      self.class.parent.normalize_result_value(result.reverseLookupByPhoneNumberResult.serviceResult.zIPOrPostalCode) if result && result.reverseLookupByPhoneNumberResult.serviceResult.methods.include?('zIPOrPostalCode')
    end

  end

end
