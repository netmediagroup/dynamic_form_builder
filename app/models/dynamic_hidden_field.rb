class DynamicHiddenField < ActiveRecord::Base
  include DynamicFieldableCommon

  has_one :dynamic_field, :as => :fieldable

  def field_attributes(params={})
    {:default_value => self.default_value}
  end

end
