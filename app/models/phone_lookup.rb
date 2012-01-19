class PhoneLookup < ActiveRecord::Base
  LOOKUP_TYPE = 'StrikeIron::ReversePhoneAddressLookupAdvanced'

  validates_format_of :phone_number, :with => /\A\d{10}\Z/, :allow_nil => false, :allow_blank => false
  validates_presence_of :lookup_type
  validates_uniqueness_of :phone_number, :scope => :lookup_type

  before_create :perform_create_lookup

  attr_accessible :phone_number, :lookup_type

  def self.get_phone(phone)
    find_or_create_by_phone_number_and_lookup_type(phone, LOOKUP_TYPE)
  end

  def self.acceptable?(phone)
    lookup = get_phone(phone)
    lookup.acceptable?
  end

  def acceptable?
    (self.status_nbr != '200' && self.cell_phone == 'F') ? false : true if self.lookup_performed_at.present?
  end

  def phone_number=(value)
    super(value) if self.lookup_performed_at.nil?
  end

protected

  def perform_create_lookup
    perform_lookup if self.lookup_performed_at.nil?
  end

  def perform_lookup
    if self.phone_number.present?
      @lookup = LOOKUP_TYPE.constantize.new(self.phone_number)
      @lookup.attributes.each do |key, value|
        self.send("#{key}=", value) if self.attributes.include?(key.to_s)
      end
      self.lookup_performed_at = Time.zone.now
    end
  end

end
