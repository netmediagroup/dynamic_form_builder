class DynamicFormBuilder
  attr_reader :form, :dynamic_attributes, :form_params

  # When calling a new DynamicFormBuilder object, this will set up the form and its dynamic attributes.
  # The dynamic attribute values can also be set.
  def initialize(form_id, form_params={})
    form_id = form_id.id if form_id.is_a?(DynamicForm)
    instance_variable_set("@form", DynamicForm.find(form_id))
    instance_variable_set("@form_params", form_params.stringify_keys!)
    instance_variable_set("@dynamic_attributes", make_dynamic_attributes)
  end

  # This will give all the form attributes that will be needed to display the actual form on the page.
  # This also uses the attribute's value in determining if the attribute is displayed in the case of dependent attributes.
  def fields
    @fields ||= self.form.fields_with_attributes(self.form_params)
  end

  def resource_information
    info = {:fields => self.fields, :params => self.form_params.empty? ? nil : self.form_params, :valid => self.form_params.empty? ? nil : self.valid?}
    info[:status_checks] = self.status_checks
    info[:validation_errors] = self.validation_errors

    return info
  end

  def duplication_attributes
    @duplication_attributes ||= self.form.dynamic_fields.duplicate_checking.inject({}) {|fields, field| fields.merge!({field.column_name.to_sym => self.dynamic_attributes[field.column_name.to_sym]}); fields }
  end

  def duplication_queries
    if @duplication_queries.nil?
      @duplication_queries = self.duplication_attributes.inject([]) {|dup_attrs, dup_attr| dup_attrs << "#{dup_attr[0].to_s} = '#{dup_attr[1].to_s}'"; dup_attrs }
      @duplication_queries << "created_at >= '#{self.form.duplication_days.days.ago.to_s(:db)}'" if !@duplication_queries.empty? && !self.form.duplication_days.blank? && self.form.duplication_days > 0
    end
    @duplication_queries
  end

  def status_checks
    self.valid? ? (self.qualified? ? 'valid' : 'unqualified') : 'invalid'
  end

  def validation_errors
    if !self.form_params.empty? && !self.valid?
      self.errors.instance_variable_get('@errors').inject({}) {|errors,error| errors.merge!(error[0] => error[1].join('|')); errors}
    end
  end

  # Since the form parameters are load when the instance is initialized, we can cache the return value.
  def valid?
    if @is_valid.nil?
      errors.clear
      validate
      @is_valid = errors.empty?
    end
    @is_valid
  end

  # Validate the form based on the fields' requirements and validations.
  def validate
    self.form.fields.each do |field|
      field_value = instance_variable_get("@dynamic_attributes").fetch(field.column_name.to_sym)

      if field_value.nil? || (!['Boolean'].include?(field.column_type) && field_value.empty?)
        if field.required?
          msg = unless field.required_error.blank?
            field.required_error
          else
            if ['DynamicCheckBox','DynamicRadioButton','DynamicSelect'].include?(field.fieldable_type)
              "Please select #{field.default_error_name}."
            else
              "Please enter your #{field.default_error_name}."
            end
          end
          errors.add(field.column_name, msg)
        end
      else
        if field.fieldable.methods.include?('has_option_value?')
          unless field.fieldable.has_option_value?(field_value)
            msg = unless field.fieldable.missing_value_error.empty?
              field.fieldable.missing_value_error
            else
              "The value submitted for #{field.default_error_name} is not an option."
            end
            errors.add(field.column_name, msg)
          end
        end
        field.dynamic_field_checks.for_validation.each do |validation_check|
          errors.add(field.column_name, validation_check.check_message) unless validation_check.check_field(field_value)
        end
      end
    end
  end

  # Since the form parameters are load when the instance is initialized, we can cache the return value.
  def qualified?
    if @is_qualifed.nil?
      qualification_errors.clear
      qualify
      @is_qualifed = qualification_errors.empty?
    end
    @is_qualifed
  end

  def qualify
    self.form.fields.each do |field|
      field_value = instance_variable_get("@dynamic_attributes").fetch(field.column_name.to_sym)

      field.dynamic_field_checks.for_qualification.each do |qualification_check|
        unless qualification_check.check_field(field_value)
          qualification_errors.add(field.column_name, qualification_check.check_message)
        end
      end
    end
  end

  def empty?
    self.fields.each do |field|
      return false if !field[:value].blank? || !default_field_value?(field)
    end
    return true
  end

  def default_field_value?(field)
    return case field[:field_type]
      when 'text_field', 'text_area' then (field[:value] == field[:prompt]) || (field[:value].blank? && field[:prompt].blank?)
      when 'select','radio_button' then (field[:value] || []).sort == (field[:default_options].first || {}).map{|k,v| v}.sort
      when 'check_box' then false
      when 'phone' then field[:value].blank?
      when 'hidden_field' then true
      else false
    end
  end

  def has_bad_words?
    self.fields.each do |field|
      return true unless InputValidator.valid_words?(field[:value])
    end
    return false
  end

  def errors
    @errors ||= ActiveRecord::Errors.new(self)
  end

  def qualification_errors
    @qualification_errors ||= ActiveRecord::Errors.new(self)
  end


private  #----------------------------------------------------------------

  def self.human_attribute_name(attr)
    return attr.humanize
  end

  def make_dynamic_attributes
    self.fields.inject({}) {|fields, field| fields.merge!({field[:column_name].to_sym => field[:value]}); fields}
  end

end