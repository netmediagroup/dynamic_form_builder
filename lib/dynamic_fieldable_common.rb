module DynamicFieldableCommon

  def field_value(params={})
    params[self.dynamic_field.column_name.to_s]
  end

  def array_items
    array_items = []
    if self.methods.include?('dynamic_array_groups')
      self.dynamic_array_groups.default_order.each do |group|
        array_items.concat(group.dynamic_array_items.default_order)
      end
    end
    array_items
  end

end