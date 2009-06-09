class DynamicArrayItem < ActiveRecord::Base
  belongs_to :dynamic_array

  named_scope :default_order, :order => 'sort ASC'

  validates_numericality_of :dynamic_array_id, :only_integer => true, :allow_nil => false, :greater_than => 0
  validates_uniqueness_of :item_display, :scope => [:dynamic_array_id, :item_value]


  def has_item_value?(value)
    value.to_s == self.item_value.to_s
  end

  def field_attributes
    {:display => self.item_display, :value => self.item_value}
  end

end
