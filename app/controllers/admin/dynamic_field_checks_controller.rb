class Admin::DynamicFieldChecksController < ApplicationController
  before_filter :load_field
  before_filter :load_field_check, :only => [:show, :edit, :update, :destroy]
  before_filter :load_new_field_check, :only => [:new, :create]
  before_filter :load_redirect_to_field_check, :only => [:new, :create, :edit, :update]

  def index
    @field_checks = @field.dynamic_field_checks
  end

  def new
  end

  def create
    if @field_check.save
      flash[:notice] = 'Field check was created.'
      redirect_to @redirect_to_field_check
    else
      render :new
    end
  end

  def show
  end

  def edit
  end

  def update
    if @field_check.update_attributes(params[:dynamic_field_check])
      flash[:notice] = 'Field check was updated.'
      redirect_to @redirect_to_field_check
    else
      render :edit
    end
  end

  def destroy
    @field_check.destroy
    flash[:notice] = 'Field check was deleted.'
    redirect_to admin_dynamic_field_dynamic_field_checks_path(@field)
  end


protected

  def load_field
    @field = DynamicField.find(params[:dynamic_field_id])
  end

  def load_field_check
    @field_check = @field.dynamic_field_checks.find(params[:id])
  end

  def load_new_field_check
    @field_check = params[:dynamic_field_check].nil? ? @field.dynamic_field_checks.new : @field.dynamic_field_checks.new(params[:dynamic_field_check])
  end

  def load_redirect_to_field_check
    @redirect_to_field_check = [:admin, @field, @field_check]
  end

end
