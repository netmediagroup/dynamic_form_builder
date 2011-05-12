class DynamicFormBuilder
  attr_reader :form, :dynamic_attributes, :form_params
  attr_accessor :displaying_step, :next_step

  # When calling a new DynamicFormBuilder object, this will set up the form and its dynamic attributes.
  # The dynamic attribute values can also be set.
  def initialize(form_id, form_params={})
    form_params.stringify_keys!

    form_id = form_id.id if form_id.is_a?(DynamicForm)
    instance_variable_set("@form", DynamicForm.find(form_id))

    self.displaying_step = form_params['displaying_step'].to_i if !form_params['displaying_step'].nil? && self.form.use_multistep?
    self.next_step = self.displaying_step if self.displaying_step

    instance_variable_set("@form_params", form_params)
    instance_variable_set("@dynamic_attributes", make_dynamic_attributes)
  end

  # This will give all the form attributes that will be needed to display the actual form on the page.
  # This also uses the attribute's value in determining if the attribute is displayed in the case of dependent attributes.
  def fields
    @fields ||= gather_form_fields
  end

  def resource_information
    if @resource_information.nil?
      @resource_information = {
        :status_checks => self.status_checks,
        :validation_errors => self.validation_errors,
        :displaying_step => self.next_step,
        :last_step => self.form.last_step,
        :fields => self.fields.dup,
        :params => (self.form_params.empty? ? nil : self.form_params),
        :valid => (self.form_params.empty? ? nil : self.valid?)
      }

      @resource_information[:fields].each do |field|
        field.delete(:save_value)
        field[:value] = field[:value].inject({}) {|values, v| values[field[:value].index(v)] = v; values} if field[:value].is_a?(Array)
      end
    end
    @resource_information
  end

  def duplication_attributes
    @duplication_attributes ||= self.form.dynamic_fields.duplicate_checking.inject({}) {|fields, field| fields.merge!({field.column_name.to_sym => self.dynamic_attributes[field.column_name.to_sym]}); fields }
  end

  def duplication_queries
    if @duplication_queries.nil?
      # @duplication_queries = self.duplication_attributes.inject([]) {|dup_attrs, dup_attr| dup_attrs << ActiveRecord::Base.send(:sanitize_sql_for_conditions, ["#{dup_attr[0].to_s} = ?", dup_attr[1].to_s]); dup_attrs }
      @duplication_queries = self.duplication_attributes.inject([]) {|dup_attrs, dup_attr| dup_attrs << ActiveRecord::Base.send(:sanitize_sql_for_assignment, ["#{dup_attr[0].to_s} = ?", dup_attr[1].to_s]); dup_attrs }
      @duplication_queries << "created_at >= '#{self.form.duplication_days.days.ago.to_s(:db)}'" if !@duplication_queries.empty? && !self.form.duplication_days.blank? && self.form.duplication_days > 0
    end
    @duplication_queries
  end

  def status_checks
    if self.valid?
      if self.displaying_step && self.form.use_multistep? && self.displaying_step < self.form.last_step
        self.next_step = self.displaying_step + 1
        @form_params['displaying_step'] = self.next_step
        @fields = gather_form_fields
        return 'step'
      else
        return self.qualified? ? 'valid' : 'unqualified'
      end
    else
      return 'invalid'
    end
  end

  def validation_errors
    if !self.form_params.empty? && !self.valid?
      self.errors.instance_variable_get('@errors').inject({}) {|errors,error| errors.merge!(error[0] => error[1].join('|')); errors}
    end
  end

  # Since the form parameters are loaded when the instance is initialized, we can cache the return value.
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
      validate_form_field(field, errors) if self.displaying_step.nil? || self.form.use_multistep? == false || field.step <= self.displaying_step
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
      return false if !field[:value].blank? && !default_field_value?(field)
    end
    return true
  end

  def default_field_value?(field)
    return case field[:field_type]
      when 'text_field', 'text_area' then (field[:value] == field[:prompt]) || (field[:value].blank? && field[:prompt].blank?)
      when 'select','radio_button' then (field[:default_option].blank? ? false : field[:value] == field[:default_option].item_value)
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

  def step_errors
    @step_errors ||= ActiveRecord::Errors.new(self)
  end

  def qualification_errors
    @qualification_errors ||= ActiveRecord::Errors.new(self)
  end


private  #----------------------------------------------------------------

  def self.human_attribute_name(attr)
    return attr.humanize
  end

  def gather_form_fields
    self.form.fields_with_attributes(self.form_params)
  end

  def make_dynamic_attributes
    self.fields.inject({}) {|fields, field| fields.merge!({field[:column_name].to_sym => field[:value]}); fields}
  end

  def validate_form_field(field, error_object)
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
        error_object.add(field.column_name, msg)
      end
    else
      if field.fieldable.methods.include?('has_option_value?')
        correct_values = true
        field_values = field_value.is_a?(Array) ? field_value : [field_value]
        field_values.each do |fv|
          correct_values = false unless field.fieldable.has_option_value?(fv)
        end

        if correct_values == false
          msg = unless field.fieldable.missing_value_error.empty?
            field.fieldable.missing_value_error
          else
            "The value submitted for #{field.default_error_name} is not an option."
          end
          error_object.add(field.column_name, msg)
        end
      end

      field.dynamic_field_checks.for_validation.each do |validation_check|
        error_object.add(field.column_name, validation_check.check_message) unless validation_check.check_field(field_value)
      end

      field.dynamic_field_checks.for_last_validation.each do |validation_check|
        unless validation_check.check_field(field_value)
          error_object.add(field.column_name, validation_check.check_message)
          break
        end
      end if error_object.instance_variable_get("@errors").has_key?(field.column_name) == false
    end
  end

end