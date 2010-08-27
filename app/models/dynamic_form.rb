class DynamicForm < ActiveRecord::Base
  has_many :dynamic_fields_solo, :class_name => 'DynamicField', :dependent => :destroy
  has_many :dynamic_fields, :include => :fieldable
  has_many :leads, :foreign_key => 'form_id'

  named_scope :active, :conditions => ["active = ?", true]
  named_scope :named_order, :order => 'name ASC'

  validates_presence_of :name

  after_update :expire_webservice_cache

  def fields
    @fields ||= self.dynamic_fields.with_parents.with_formats.active.default_order
  end

  def fields_with_attributes(params={})
    params.stringify_keys!
    self.fields.inject([]) {|fields, dynamic_field| fields << dynamic_field.field_attributes(params); fields}
  end

  def with_fields_and_attributes(params={})
    params.stringify_keys!
    self.attributes.merge(:displaying_step => params['displaying_step'], :last_step => last_step, :fields => self.fields_with_attributes(params))
  end

  def last_step(options={})
    self.dynamic_fields_solo.maximum('step', options)
  end

protected

  def expire_webservice_cache
    ActionController::Base.new.expire_fragment %r{webservices/sites/\d*/forms/#{self.id}}

    CacheControl.expire_form_cache(self.id) rescue nil
  end

end
