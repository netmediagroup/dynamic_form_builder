class DynamicArrayItem < ActiveRecord::Base
  belongs_to :dynamic_array

  named_scope :default_order, :order => 'sort ASC'

  validates_numericality_of :dynamic_array_id, :only_integer => true, :allow_nil => false, :greater_than => 0
  validates_uniqueness_of :item_display, :scope => [:dynamic_array_id, :item_value]
  validates_presence_of :item_display, :if => Proc.new { |item| item.item_value.blank? }, :message => "can't be blank if the value is blank"
  validates_presence_of :item_value, :if => Proc.new { |item| item.item_display.blank? }, :message => "can't be blank if the display is blank"

  before_create :set_sort


  def has_item_value?(value, case_sensitive=true)
    case_sensitive == false ? value.to_s.downcase == self.item_value.to_s.downcase : value.to_s == self.item_value.to_s
  end

  def field_attributes
    {:display => self.item_display, :value => self.item_value}
  end


private

  def set_sort
    self.sort = self.dynamic_array.dynamic_array_items.count if self.sort.nil? || self.sort == 0
  end

end
