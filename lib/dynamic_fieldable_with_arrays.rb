module DynamicFieldableWithArrays

  def self.included(base)
    base.has_many :dynamic_array_groups, :as => :dynamic_arrayable, :dependent => :destroy
    # base.has_many :dynamic_arrays, :through => :dynamic_array_groups, :order => 'sort ASC'
  end

  def has_option_value?(value)
    dynamic_array_groups.detect{|group| group.has_item_value?(value)}
  end

end