class DynamicForm < ActiveRecord::Base
  has_many :dynamic_fields_solo, :class_name => 'DynamicField', :dependent => :destroy
  has_many :dynamic_fields, :include => :fieldable
  has_many :leads, :foreign_key => 'form_id'

  validates_presence_of :name
  validates_uniqueness_of :name


  def fields
    @fields ||= self.dynamic_fields.with_parents.with_formats.active.default_order
  end

  def fields_with_attributes(params={})
    self.fields.inject([]) {|fields, dynamic_field| fields << dynamic_field.field_attributes(params); fields}
  end

end
