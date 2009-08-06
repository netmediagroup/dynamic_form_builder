class DynamicFieldableDefaultArrayItem < ActiveRecord::Base
  belongs_to :defaultable, :polymorphic => true, :touch => true
  belongs_to :dynamic_array_item

  validates_presence_of :defaultable, :dynamic_array_item


  def defaultable_type=(sType)
    super(sType.to_s.classify.constantize.base_class.to_s) unless sType.blank?
  end

end
