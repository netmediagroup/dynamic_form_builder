class DynamicArray < ActiveRecord::Base
  has_many :dynamic_array_items, :dependent => :destroy
  has_many :dynamic_array_groups

  validates_presence_of :name
  validates_uniqueness_of :name

  def has_item_value?(value)
    dynamic_array_items.detect{|dynamic_array_item| dynamic_array_item.has_item_value?(value)}
  end

end
