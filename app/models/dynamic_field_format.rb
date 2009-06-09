class DynamicFieldFormat < ActiveRecord::Base
  WHEN_TYPES = ['display','delivery','database']

  serialize :match

  belongs_to :dynamic_field

  named_scope :default_order, :order => 'sort ASC'
  named_scope :when, lambda { |when_param| {:conditions => ["format_when = ?", when_param]} }

  validates_presence_of :dynamic_field, :format_when, :sort, :match, :replace
  validates_inclusion_of :format_when, :in => WHEN_TYPES
end
