class DynamicArray < ActiveRecord::Base
  has_many :dynamic_array_items, :dependent => :destroy
  has_many :dynamic_array_groups

  validates_presence_of :name
  validates_uniqueness_of :name

  after_update :touch_array_groups

  def has_item_value?(value, case_sensitive=true)
    dynamic_array_items.detect{|dynamic_array_item| dynamic_array_item.has_item_value?(value, case_sensitive)}
  end

protected

  def touch_array_groups
    self.dynamic_array_groups.each {|group| group.touch}
  end

end
