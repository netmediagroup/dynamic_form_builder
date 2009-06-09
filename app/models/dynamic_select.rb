class DynamicSelect < ActiveRecord::Base
  include DynamicFieldableCommon

  has_one :dynamic_field, :as => :fieldable

  has_many :dynamic_array_groups, :as => :dynamic_arrayable, :dependent => :destroy
  # has_many :dynamic_arrays, :through => :dynamic_array_groups, :order => 'sort ASC'
  has_many :dynamic_fieldable_default_array_items, :as => :defaultable, :dependent => :destroy
  has_many :default_items, :through => :dynamic_fieldable_default_array_items, :source => :dynamic_array_item


  def field_attributes(params={})
    {
      :combine_option_groups => self.combine_option_groups, :allow_blank => self.allow_blank, :prompt => self.prompt, :html_options => {:size => self.size},
      :option_groups => self.dynamic_array_groups.default_order.inject([]) {|groups, dynamic_array_group| groups << dynamic_array_group.field_attributes; groups},
      :default_options => self.default_items.default_order.inject([]) {|items, default_item| items << default_item.field_attributes; items}
    }
  end

  def has_option_value?(value)
    dynamic_array_groups.detect{|group| group.has_item_value?(value)}
  end

end
