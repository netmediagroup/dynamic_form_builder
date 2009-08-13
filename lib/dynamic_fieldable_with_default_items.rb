module DynamicFieldableWithDefaultItems

  def self.included(base)
    base.has_many :dynamic_fieldable_default_array_items, :as => :defaultable, :dependent => :destroy
    base.has_many :default_items, :through => :dynamic_fieldable_default_array_items, :source => :dynamic_array_item
  end

end