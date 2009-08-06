class DynamicTextField < ActiveRecord::Base
  include DynamicFieldableCommon

  def field_attributes(params={})
    {:prompt => self.prompt, :html_options => {:maxlength => self.maxlength, :size => self.size}}
  end

end
