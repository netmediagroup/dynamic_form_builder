class PhoneLookup < ActiveRecord::Base
  validates_format_of :phone_number, :with => /\A\d{10}\Z/, :allow_nil => false, :allow_blank => false
  validates_uniqueness_of :phone_number

  before_create :perform_create_lookup

  attr_accessible :phone_number

  def phone_number=(value)
    super(value) if self.lookup_performed_at.nil?
  end

  def acceptable?
    (self.status_nbr != '200' && self.cell_phone == 'F') ? false : true unless self.lookup_performed_at.nil?
  end

protected

  def perform_create_lookup
    perform_lookup if self.lookup_performed_at.nil?
  end

  def perform_lookup
    unless self.phone_number.nil?
      @lookup = StrikeIron::ReversePhoneAddressLookup.new(self.phone_number)
      @lookup.attributes.each do |key, value|
        self.send("#{key}=", value) if self.attributes.include?(key.to_s)
      end
      self.lookup_performed_at = Time.zone.now
    end
  end

end
