module DynamicFieldableCommon

  def self.included(base)
    base.has_one :dynamic_field, :as => :fieldable
    base.after_save :touch_field
  end

  def field_value(params={})
    fieldable_value(params[self.dynamic_field.column_name.to_s])
  end

  def fieldable_value(value)
    self.dynamic_field.column_type_value(value)
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

protected

  def touch_field
    self.dynamic_field.touch unless self.dynamic_field.nil?
  end

end