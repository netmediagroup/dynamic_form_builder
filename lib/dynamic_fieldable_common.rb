module DynamicFieldableCommon

  def field_value(params={})
    params[self.dynamic_field.column_name.to_s]
  end

end