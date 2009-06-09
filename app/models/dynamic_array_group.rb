class DynamicArrayGroup < ActiveRecord::Base
  belongs_to :dynamic_arrayable, :polymorphic => true
  belongs_to :dynamic_array
  has_many :dynamic_array_items, :through => :dynamic_array

  named_scope :default_order, :order => 'sort ASC'

  validates_presence_of :dynamic_arrayable, :name
  validates_numericality_of :dynamic_array_id, :only_integer => true, :allow_nil => false, :greater_than => 0


  def field_attributes
    {
      :label => self.label || self.name,
      :options => self.dynamic_array_items.default_order.inject([]) {|items, dynamic_array_item| items << dynamic_array_item.field_attributes; items}
    }
  end

  def has_item_value?(value)
    dynamic_array.has_item_value?(value)
  end

  def dynamic_arrayable_type=(sType)
    super(sType.to_s.classify.constantize.base_class.to_s) unless sType.blank?
  end

end
