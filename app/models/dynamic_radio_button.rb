class DynamicRadioButton < ActiveRecord::Base
  include DynamicFieldableCommon
  include DynamicFieldableWithArrays
  include DynamicFieldableWithDefaultItem

  def field_attributes(params={})
    {
      :combine_option_groups => self.combine_option_groups,
      :option_groups => self.dynamic_array_groups.default_order.inject([]) {|groups, dynamic_array_group| groups << dynamic_array_group.field_attributes; groups},
      :default_option => self.default_item
    }
  end

end
