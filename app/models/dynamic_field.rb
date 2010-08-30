class DynamicField < ActiveRecord::Base
  FIELDABLE_TYPES = ['DynamicCheckBox','DynamicHiddenField','DynamicPhone','DynamicRadioButton','DynamicSelect','DynamicTextArea','DynamicTextField']
  COLUMN_TYPES = ['Binary','Boolean','Date','Datetime','Decimal','Float','Integer','String','Text','Time','Timestamp']

  belongs_to :dynamic_form, :touch => true
  belongs_to :fieldable, :polymorphic => true, :dependent => :destroy
  has_many :dynamic_field_checks, :dependent => :destroy
  has_many :dynamic_field_formats, :dependent => :destroy

  has_many :dynamic_field_dependency_parents, :class_name => 'DynamicFieldDependency', :foreign_key => 'child_id', :dependent => :delete_all
  has_many :dynamic_field_dependency_children, :class_name => 'DynamicFieldDependency', :foreign_key => 'parent_id', :dependent => :delete_all
  has_and_belongs_to_many :parents, :class_name => 'DynamicField', :join_table => 'dynamic_field_dependencies', :association_foreign_key => 'parent_id', :foreign_key => 'child_id', :before_add => :adding_parent
  has_and_belongs_to_many :children, :class_name => 'DynamicField', :join_table => 'dynamic_field_dependencies', :association_foreign_key => 'child_id', :foreign_key => 'parent_id', :before_add => :adding_child

  named_scope :active, :conditions => ["active = ?", true]
  named_scope :duplicate_checking, :conditions => ["check_duplication = ?", true]
  named_scope :step, lambda { |step| {:conditions => ["step = ?", step]} }
  named_scope :default_order, :order => 'step ASC, sort ASC'
  named_scope :with_parents, :include => :parents # To help reduce database queries.
  named_scope :with_formats, :include => :dynamic_field_formats # To help reduce database queries.

  validates_presence_of :dynamic_form_id, :fieldable, :column_name
  validates_uniqueness_of :column_name, :scope => :dynamic_form_id
  validates_format_of :column_name, :with => /\A[A-Za-z]\w+[A-Za-z0-9]\Z/, :allow_nil => true, :allow_blank => true
  validates_inclusion_of :active, :required, :check_duplication, :in => [true, false]
  validates_inclusion_of :fieldable_type, :in => FIELDABLE_TYPES
  validates_inclusion_of :column_type, :in => COLUMN_TYPES

  before_create :set_sort


  def fieldable_type=(sType)
    super(sType.to_s.classify.constantize.base_class.to_s) unless sType.blank?
  end

  def field_type
    self.fieldable_type.sub('Dynamic','').underscore unless self.fieldable_type.blank?
  end

  def dynamic_attributes(params={})
    {self.column_name.to_sym => params[self.column_name]}
  end

  def field_attributes(params={})
    params.stringify_keys!
    {
      :required => self.required,
      :column_name => self.column_name,
      :input_name => params['form_token'],
      :label => self.label,
      :display => self.display_field?(params),
      :field_type => self.field_type,
      :value => self.fieldable.field_value(params),#self.format(self.fieldable.field_value(params), 'display'), # I'm not sure now if formatting will be used.
      :save_value => self.fieldable.save_value(params),
      :column_type => self.column_type
    }.merge(self.fieldable.field_attributes(params))
  end

  def display_field?(params={})
    if params['displaying_step'].nil?
      step_display = true
    else
      step_display = params['displaying_step'].to_i == self.step
    end

    if self.parents.empty? # Database queries will be significantly reduced if self.parents are preloaded.
      parents_display = true
    else
      fulfilled_parents = true
      parents.each do |parent|
        fulfilled_parents = false unless parent.fulfilled?(params)
      end
      parents_display = fulfilled_parents
    end

    return step_display && parents_display
  end

  def fulfilled?(params={})
    params[self.column_name.to_sym]
  end

  def format(value, format_when)
    self.dynamic_field_formats.default_order.when(format_when).each do |dynamic_field_format|
      value.gsub!(dynamic_field_format.match, dynamic_field_format.replace)
    end unless self.dynamic_field_formats.empty? # Database queries will be significantly reduced if self.dynamic_field_formats are preloaded.
    return value
  end

  def default_error_name
    return self.label.empty? ? self.column_name : "\"#{self.label}\"";
  end

  def column_type_value(value)
    return case self.column_type
    when 'Boolean'
      if !value.nil? && (value.is_a?(TrueClass) || (value.is_a?(String) && (!(value =~ /(true|yes)/i).nil? || value.to_i > 0)) || (value.is_a?(Integer) && value > 0))
        true
      elsif !value.nil? && (value.is_a?(FalseClass) || (value.is_a?(String) && (!(value =~ /(false|no)/i).nil? || value.to_i <= 0)) || (value.is_a?(Integer) && value <= 0))
        false
      end
    else value
    end
  end

  def last_step_but_not_me
    (self.new_record? ? self.dynamic_form.last_step : self.dynamic_form.last_step(:conditions => ["#{self.class.quoted_table_name}.id <> ?", self.id])) || 0
  end

private

  def adding_parent(dynamic_field)
    adding_dependent('parent', dynamic_field)
  end

  def adding_child(dynamic_field)
    adding_dependent('child', dynamic_field)
  end

  def adding_dependent(dependent_type, dynamic_field)
    if dependent_type == 'parent' && self.parents.include?(dynamic_field)
      raise Exception.new("#{dynamic_field.column_name} is already a parent field for this.")
    elsif dependent_type == 'child' && self.children.include?(dynamic_field)
      raise Exception.new("#{dynamic_field.column_name} is already a child field for this.")
    elsif dynamic_field.id == self.id
      raise Exception.new("Field cannot depend on itself.")
    end
  end

  def set_sort
    self.sort = self.dynamic_form.dynamic_fields_solo.count if self.sort.nil? || self.sort == 0
  end

end
