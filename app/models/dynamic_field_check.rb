class DynamicFieldCheck < ActiveRecord::Base
  CHECK_FORS = ['qualify','validate'].freeze
  QUALIFYING_TYPES = ['array_true','array_false','custom_true','custom_false','length','max_length','min_length','numerical','split_true','split_false'].freeze
  VALIDATING_TYPES = ['array_true','array_false','custom_true','custom_false','email','length','max_length','min_length','numerical','phone_lookup','phone_validity','split_true','split_false'].freeze
  # CHECK_TYPES = (QUALIFYING_TYPES + VALIDATING_TYPES).uniq.sort.freeze
  LAST_CHECK_TYPES = ['phone_validity','phone_lookup'].freeze # In order of priority. These are done last and are only checked if there are no errors.
  CHECK_TYPES_THAT_REQUIRE_VALUE = ['array_true','array_false','custom_true','custom_false','length','max_length','min_length','split_true','split_false'].freeze

  SPLIT_SEPARATOR = '|'

  belongs_to :dynamic_field

  named_scope :for_qualification, lambda {{ :conditions => "check_for = 'qualify'" }}
  named_scope :for_validation, lambda {{ :conditions => "check_for = 'validate' AND check_type NOT IN ('#{LAST_CHECK_TYPES.join("', '")}')" }}
  named_scope :for_last_validation, lambda {{ :conditions => "check_for = 'validate' AND check_type IN ('#{LAST_CHECK_TYPES.join("', '")}')", :order => "check_type = '#{LAST_CHECK_TYPES.join("' DESC, check_type = '")}' DESC" }}

  validates_presence_of :dynamic_field
  validates_inclusion_of :check_for, :in => CHECK_FORS
  validates_inclusion_of :check_type, :in => QUALIFYING_TYPES, :if => Proc.new {|dfc| dfc.check_for == 'qualify' }
  validates_inclusion_of :check_type, :in => VALIDATING_TYPES, :if => Proc.new {|dfc| dfc.check_for == 'validate' }
  validates_presence_of :check_value, :if => :requires_value
  validates_inclusion_of :case_sensitive, :in => [true, false]


  def check_value=(value)
    value.gsub!(/\r?\n/, SPLIT_SEPARATOR) if ['split_true','split_false'].include?(self.check_type)
    super(value)
  end

  def descriptive_type
    case self.check_type
      when 'array_true' then 'Matching Value'
      when 'array_false' then 'Non-Matching Value'
      when 'custom_true' then 'True Regular Expression'
      when 'custom_false' then 'False Regular Expression'
      when 'email' then 'Email Address'
      when 'length' then 'Length'
      when 'max_length' then 'Maximum Length'
      when 'min_length' then 'Minimum Length'
      when 'phone_lookup' then 'Phone Number Lookup'
      when 'phone_validity' then 'Phone Number Validity'
      when 'numerical' then 'Numerical'
      when 'split_true' then 'Matching Value'
      when 'split_false' then 'Non-Matching Value'
    end
  end

  def descriptive_value
    case self.check_type
      when 'array_true','array_false' then value_array.dynamic_array_items.map{|i| i.item_value}.join('<br>')
      when 'custom_true','custom_false','max_length','min_length','length' then self.check_value
      when 'email' then value_email
      when 'phone_validity' then 'A common set of invalid phone number combinations.'
      when 'split_true','split_false' then value_split.join('<br>')
      when 'numerical','phone_lookup' then ''
    end
  end

  def check_field(field_value)
    field_value = formatted_value(field_value.dup)
    case self.check_type
      when 'array_true'
        !field_value.nil? && !check_array(field_value)
      when 'array_false'
        field_value.nil? || check_array(field_value)
      when 'custom_true'
        !field_value.nil? && !check_custom(field_value)
      when 'custom_false'
        field_value.nil? || check_custom(field_value)
      when 'email'
        !field_value.nil? && !check_custom(field_value, value_email)
      when 'length'
        !field_value.nil? && field_value.length == self.check_value.to_i
      when 'max_length'
        !field_value.nil? && field_value.length <= self.check_value.to_i
      when 'min_length'
        !field_value.nil? && field_value.length >= self.check_value.to_i
      when 'numerical'
        !field_value.nil? && !field_value.match(self.check_value.blank? ? /\A[+\-]?\d+\Z/ : self.check_value).nil?
      when 'phone_lookup'
        !field_value.nil? && check_phone_lookup(field_value)
      when 'phone_validity'
        !field_value.nil? && check_phone_validity(field_value)
      when 'split_true'
        !field_value.nil? && check_split(field_value)
      when 'split_false'
        field_value.nil? || !check_split(field_value)
    end
  end

  def check_message
    unless self.custom_message.blank?
      return self.custom_message
    else
      msg = case self.check_type
        when 'array_true'     then self.message(:inclusion)
        when 'array_false'    then self.message(:exclusion)
        when 'custom_true'    then self.message(:invalid)
        when 'custom_false'   then self.message(:invalid)
        when 'email'          then self.message(:invalid)
        when 'length'         then self.message(:wrong_length)
        when 'max_length'     then self.message(:too_long)
        when 'min_length'     then self.message(:too_short)
        when 'numerical'      then self.message(:not_a_number)
        when 'phone_lookup'   then self.message(:invalid)
        when 'phone_validity' then self.message(:invalid)
        when 'split_true'     then self.message(:inclusion)
        when 'split_false'    then self.message(:exclusion)
      end
      return "#{self.dynamic_field.default_error_name} #{msg}"
    end
  end

  def message(type)
    return case type.to_sym
      # when :accepted     then "must be accepted"
      # when :blank        then "can't be blank"
      # when :confirmation then "doesn't match confirmation"
      # when :empty        then "can't be empty"
      when :exclusion    then "is reserved"
      when :inclusion    then "is not included in the list"
      when :invalid      then "is invalid"
      when :not_a_number then "is not a number"
      # when :taken        then "has already been taken"
      when :too_long     then "is too long (maximum is #{self.check_value} characters)"
      when :too_short    then "is too short (minimum is #{self.check_value} characters)"
      when :wrong_length then "is the wrong length (should be #{self.check_value} characters)"
    end
  end

  def formatted_value(field_value)
    match = self.format_match
    match = '\D' if ['phone_lookup','phone_validity'].include?(self.check_type) && match.blank?

    replace = self.format_replace
    replace = '' if ['phone_lookup','phone_validity'].include?(self.check_type) && replace.blank?

    unless match.blank?
      field_value.gsub!(Regexp.new(match), replace)
    end
    field_value
  end

  def value_array
    @value_array ||= DynamicArray.find_by_id(self.check_value) if ['array_true','array_false'].include?(self.check_type)
  end

  def value_email
    self.check_value.blank? ? '\A[\w-]+(\.[\w-]+)*@([\w-]+(\.[\w-]+)*?\.[a-zA-Z]{2,6}|(\d{1,3}\.){3}\d{1,3})(:\d{4})?\Z' : self.check_value
  end

  def value_split
    @value_split ||= (self.case_sensitive? ? self.check_value.split(SPLIT_SEPARATOR) : self.check_value.downcase.split(SPLIT_SEPARATOR)) if ['split_true','split_false'].include?(self.check_type) && !self.check_value.nil?
  end


protected

  def check_array(field_value)
    self.value_array.has_item_value?(field_value, self.case_sensitive).nil?
  end

  def check_custom(field_value, reg = self.check_value)
    self.case_sensitive? ? field_value.match(reg).nil? : field_value.match(Regexp.new(reg, Regexp::IGNORECASE)).nil?
  end

  def check_phone_lookup(field_value)
    lookup = PhoneLookup.find_or_create_by_phone_number(field_value)
    lookup.acceptable?
  end

  def check_phone_validity(field_value)
    InputValidator.valid_phone_number?(field_value)
  end

  def check_split(field_value)
    self.case_sensitive? ? self.value_split.include?(field_value) : self.value_split.include?(field_value.downcase)
  end

  def requires_value
    CHECK_TYPES_THAT_REQUIRE_VALUE.include?(self.check_type)
  end

end
