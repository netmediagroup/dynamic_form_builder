class Admin::DynamicArrayGroupsController < ApplicationController
  before_filter :load_field
  before_filter :load_array_groups, :only => [:index, :edit_sort]
  before_filter :load_array_group, :only => [:show, :edit, :update, :destroy]
  before_filter :load_new_array_group, :only => [:new, :create]
  before_filter :load_arrays, :only => [:new, :create, :edit, :update]
  before_filter :load_redirect_to_array_group, :only => [:new, :create, :edit, :update]

  def index
  end

  def new
  end

  def create
    if @array_group.save
      flash[:notice] = 'Array group was created.'
      redirect_to @redirect_to_array_group
    else
      render :new
    end
  end

  def show
  end

  def edit
  end

  def update
    if @array_group.update_attributes(params[:dynamic_array_group])
      flash[:notice] = 'Array group was updated.'
      redirect_to @redirect_to_array_group
    else
      render :edit
    end
  end

  def destroy
    @array_group.destroy
    flash[:notice] = 'Array group was deleted.'
    redirect_to admin_dynamic_field_dynamic_array_groups_path(@field)
  end

  def edit_sort
  end

  def update_sort
    params[:groups_list].each_index do |i|
      id = params[:groups_list].fetch(i)
      DynamicArrayGroup.find(id).update_attribute('sort', i)
    end
    render :nothing => true
  end


protected

  def load_field
    @field = DynamicField.find(params[:dynamic_field_id])
  end

  def load_array_groups
    @array_groups = @field.fieldable.dynamic_array_groups.default_order
  end

  def load_array_group
    @array_group = @field.fieldable.dynamic_array_groups.find(params[:id])
  end

  def load_new_array_group
    @array_group = params[:dynamic_array_group].nil? ? @field.fieldable.dynamic_array_groups.new : @field.fieldable.dynamic_array_groups.new(params[:dynamic_array_group])
  end

  def load_arrays
    @arrays = DynamicArray.all(:order => 'name ASC')
  end

  def load_redirect_to_array_group
    @redirect_to_array_group = [:admin, @field, @array_group]
  end

end
