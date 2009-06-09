class DynamicTextArea < ActiveRecord::Base
  include DynamicFieldableCommon

  has_one :dynamic_field, :as => :fieldable

  def field_attributes(params={})
    {:prompt => self.prompt, :html_options => {:rows => self.rows, :cols => self.columns, :wrap => self.wordwrapping}}
  end

end
