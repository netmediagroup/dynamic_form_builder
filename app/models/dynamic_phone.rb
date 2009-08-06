class DynamicPhone < ActiveRecord::Base
  include DynamicFieldableCommon

  def field_attributes(params={})
    attrs = {:separate_inputs => self.separate_inputs, :dividers => self.dividers}

    column_name = self.dynamic_field.column_name
    if self.separate_inputs
      ['area','prefix','suffix'].each do |phone_type|
        attrs[phone_type.to_sym] = params["#{column_name}_#{phone_type}"]
        attrs["#{phone_type}_prompt".to_sym] = ''
      end
    end

    return attrs
  end

  def field_value(params={})
    column_name = self.dynamic_field.column_name
    if self.separate_inputs
      merged = (params["#{column_name}_area"].to_s + params["#{column_name}_prefix"].to_s + params["#{column_name}_suffix"].to_s)
      return merged.blank? ? nil : merged
    else
      params[column_name.to_s]
    end
  end

end
