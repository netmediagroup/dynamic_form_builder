class DynamicTextField < ActiveRecord::Base
  include DynamicFieldableCommon

  has_one :dynamic_field, :as => :fieldable

  def field_attributes(params={})
    {:prompt => self.prompt, :html_options => {:maxlength => self.maxlength, :size => self.size}}
  end

end
