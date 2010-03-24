class DynamicHiddenField < ActiveRecord::Base
  include DynamicFieldableCommon

  def field_attributes(params={})
    {:default_value => self.default_value}
  end

  def field_value(params={})
    field_value = params[self.dynamic_field.column_name.to_s] || self.default_value
    field_value.strip! unless field_value.nil?
    field_value
  end

end
