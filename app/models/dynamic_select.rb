class DynamicSelect < ActiveRecord::Base
  include DynamicFieldableCommon
  include DynamicFieldableWithArrays
  include DynamicFieldableWithDefaultItem

  def field_attributes(params={})
    {
      :combine_option_groups => self.combine_option_groups, :allow_blank => self.allow_blank, :prompt => self.prompt,
      :option_groups => self.dynamic_array_groups.default_order.inject([]) {|groups, dynamic_array_group| groups << dynamic_array_group.field_attributes; groups},
      :default_option => self.default_item
    }
  end

end
