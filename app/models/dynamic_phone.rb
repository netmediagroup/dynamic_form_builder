class DynamicPhone < ActiveRecord::Base
  include DynamicFieldableCommon

  def field_attributes(params={})
    attrs = {:separate_inputs => self.separate_inputs, :dividers => self.dividers}

    column_name = self.dynamic_field.column_name
    if self.separate_inputs
      ['area','prefix','suffix'].each do |phone_type|
        value = params["#{column_name}_#{phone_type}"]
        value = case phone_type
          when 'area' then params[column_name][0..2]
          when 'prefix' then params[column_name][3..5]
          when 'suffix' then params[column_name][6..9]
        end if value.nil? && !params[column_name].blank?

        attrs[phone_type.to_sym] = value
        attrs["#{phone_type}_prompt".to_sym] = ''
      end
    end

    return attrs
  end

  def field_value(params={})
    column_name = self.dynamic_field.column_name

    if self.separate_inputs
      merged = (params["#{column_name}_area"].to_s + params["#{column_name}_prefix"].to_s + params["#{column_name}_suffix"].to_s)
      value = merged unless merged.blank?
    else
      value = params[column_name.to_s]
      value.strip! unless value.nil?
    end
    return value
  end

end
