class DynamicMultiCheckBox < ActiveRecord::Base
  include DynamicFieldableCommon
  include DynamicFieldableWithArrays
  include DynamicFieldableWithDefaultItems

  def field_attributes(params={})
    {
      :combine_option_groups => self.combine_option_groups,
      :option_groups => self.dynamic_array_groups.default_order.inject([]) {|groups, dynamic_array_group| groups << dynamic_array_group.field_attributes; groups},
      :default_options => self.default_items.default_order.inject([]) {|items, default_item| items << default_item.field_attributes; items}
    }
  end

  def field_value(params={})
    if @field_value.nil?
      @field_value = params[self.dynamic_field.column_name.to_s]
      unless @field_value.nil?
        @field_value = [@field_value] if @field_value.is_a?(String)
        @field_value = @field_value.values if @field_value.is_a?(Hash)

        @field_value.collect!{|v| v.is_a?(String) ? v.strip : v }
      end
    end
    @field_value
  end

end
