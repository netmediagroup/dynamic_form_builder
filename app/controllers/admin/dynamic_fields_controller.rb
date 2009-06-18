class Admin::DynamicFieldsController < ApplicationController
  before_filter :load_form, :only => [:index, :new, :create]
  before_filter :load_field, :only => [:show, :edit, :update, :destroy]
  before_filter :load_new_field, :only => [:new, :create]
  before_filter :load_form_action_new, :only => [:new, :create]
  before_filter :load_form_action_edit, :only => [:edit, :update]

  def index
    @fields = @dynamic_form.dynamic_fields.default_order
  end

  def new
  end

  def create
    @fieldable = @field.fieldable_type.classify.constantize.new(params[:fieldable]) if @field.fieldable_type
    @field.fieldable = @fieldable if @fieldable

    field_valid = @field.valid?
    fieldable_valid = @fieldable.valid? if @fieldable
    if field_valid && fieldable_valid
      begin
        DynamicField.transaction do
          @fieldable.save!
          @field.save!

          flash[:notice] = 'Field was created.'
          redirect_to [:admin, @field]
        end
      rescue ActiveRecord::RecordInvalid => e
        render :new
      end
    else
      render :new
    end
  end

  def show
  end

  def edit
  end

  def update
    field_valid = @field.update_attributes(params[:dynamic_field])
    fieldable_valid = @field.fieldable.update_attributes(params[:fieldable])
    if fieldable_valid && field_valid
      flash[:notice] = 'Field was updated.'
      redirect_to [:admin, @field]
    else
      render :edit
    end
  end

  def destroy
    @field.destroy
    flash[:notice] = 'Field was deleted.'
    redirect_to admin_dynamic_form_path(@dynamic_form)
  end

  def change_type
    unless params[:t].blank?
      render :partial => "form_#{params[:t].sub('Dynamic','').underscore}"
    else
      render :nothing => true
    end
  end


protected

  def load_form
    @dynamic_form = DynamicForm.find(params[:dynamic_form_id])
  end

  def load_field
    @field = DynamicField.find(params[:id])
  end

  def load_new_field
    @field = params[:dynamic_field].nil? ? @dynamic_form.fields.new : @dynamic_form.fields.new(params[:dynamic_field])
  end

  def load_form_action_new
    @form_action = [:admin, @dynamic_form, @field]
  end

  def load_form_action_edit
    @form_action = [:admin, @field]
  end

end
