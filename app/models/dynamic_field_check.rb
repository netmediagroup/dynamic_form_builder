class DynamicFieldCheck < ActiveRecord::Base
  CHECK_FORS = ['qualify','validate']
  CHECK_TYPES = ['array_true','array_false','custom_true','custom_false','email','length','min_length','numerical','max_length','split_true','split_false']
  CHECK_TYPES_THAT_REQUIRE_VALUE = ['array_true','array_false','custom_true','custom_false','length','min_length','max_length','split_true','split_false']

  belongs_to :dynamic_field

  named_scope :for_qualification, lambda {{ :conditions => "check_for = 'qualify'" }}
  named_scope :for_validation, lambda {{ :conditions => "check_for = 'validate'" }}

  validates_presence_of :dynamic_field
  validates_inclusion_of :check_for, :in => CHECK_FORS
  validates_inclusion_of :check_type, :in => CHECK_TYPES
  validates_presence_of :check_value, :if => :requires_value
  validates_inclusion_of :case_sensitive, :in => [true, false]


  def check_field(field_value)
    field_value = formatted_value(field_value)
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
        !field_value.nil? && !check_custom(field_value, (self.check_value || /\A[\w-]+(\.[\w-]+)*@([\w-]+(\.[\w-]+)*?\.[a-zA-Z]{2,6}|(\d{1,3}\.){3}\d{1,3})(:\d{4})?\Z/))
      when 'length'
        !field_value.nil? && field_value.length == self.check_value.to_i
      when 'min_length'
        !field_value.nil? && field_value.length >= self.check_value.to_i
      when 'max_length'
        !field_value.nil? && field_value.length <= self.check_value.to_i
      when 'numerical'
        !field_value.nil? && !field_value.match(self.check_value || /\A[+\-]?\d+\Z/).nil?
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
        when 'array_true'   then self.message(:inclusion)
        when 'array_false'  then self.message(:exclusion)
        when 'custom_true'  then self.message(:invalid)
        when 'custom_false' then self.message(:invalid)
        when 'email'        then self.message(:invalid)
        when 'length'       then self.message(:wrong_length)
        when 'min_length'   then self.message(:too_short)
        when 'max_length'   then self.message(:too_long)
        when 'numerical'    then self.message(:not_a_number)
        when 'split_true'   then self.message(:inclusion)
        when 'split_false'  then self.message(:exclusion)
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
    unless self.format_match.blank? || self.format_replace.blank?
      field_value.gsub!(Regexp.new(self.format_match), self.format_replace)
    end
    field_value
  end


protected

  def check_array(field_value)
    self.value_array.has_item_value?(field_value, self.case_sensitive).nil?
  end

  def check_custom(field_value, reg = self.check_value)
    self.case_sensitive? ? field_value.match(reg).nil? : field_value.match(Regexp.new(reg, Regexp::IGNORECASE)).nil?
  end

  def check_split(field_value)
    self.case_sensitive? ? self.value_split.include?(field_value) : self.value_split.include?(field_value.downcase)
  end

  def value_array
    @value_array ||= DynamicArray.find_by_id(self.check_value) if ['array_true','array_false'].include?(self.check_type)
  end

  def value_split
    @value_split ||= (self.case_sensitive? ? self.check_value.split('|') : self.check_value.downcase.split('|')) if ['split_true','split_false'].include?(self.check_type)
  end

  def requires_value
    CHECK_TYPES_THAT_REQUIRE_VALUE.include?(self.check_type)
  end

end
