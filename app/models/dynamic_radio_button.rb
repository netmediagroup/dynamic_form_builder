class DynamicRadioButton < ActiveRecord::Base
  include DynamicFieldableCommon
  include DynamicFieldableWithArrays

  def field_attributes(params={})
    {
      :combine_option_groups => self.combine_option_groups,
      :option_groups => self.dynamic_array_groups.default_order.inject([]) {|groups, dynamic_array_group| groups << dynamic_array_group.field_attributes; groups},
      :default_options => self.default_items.default_order.inject([]) {|items, default_item| items << default_item.field_attributes; items}
    }
  end

end
