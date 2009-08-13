module DynamicFieldableWithDefaultItem

  def self.included(base)
    base.belongs_to :default_item, :class_name => 'DynamicArrayItem'
  end

end