class DynamicHiddenField < ActiveRecord::Base
  include DynamicFieldableCommon

  has_one :dynamic_field, :as => :fieldable

  def field_attributes(params={})
    {:default_value => self.default_value}
  end

  def field_value(params={})
    # params[self.dynamic_field.column_name.to_s] || self.default_value
    self.default_value
  end

end
