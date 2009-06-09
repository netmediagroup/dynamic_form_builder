class DynamicFieldDependency < ActiveRecord::Base
  belongs_to :parent, :class_name => 'DynamicField'
  belongs_to :child, :class_name => 'DynamicField'

  validates_presence_of :child_id, :parent_id
end
