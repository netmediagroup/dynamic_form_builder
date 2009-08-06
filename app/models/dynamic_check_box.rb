class DynamicCheckBox < ActiveRecord::Base
  include DynamicFieldableCommon

  validates_presence_of :input_value

  def field_attributes(params={})
    value = self.field_value(params)
    {:checked => (value.nil? ? self.default_checked? : (value == self.input_value ? true : false)), :input_label => self.input_label, :input_value => self.input_value}
  end

end
