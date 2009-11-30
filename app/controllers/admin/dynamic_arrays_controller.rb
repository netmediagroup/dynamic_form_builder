class Admin::DynamicArraysController < ApplicationController
  before_filter :load_arrays, :only => [:index]
  before_filter :load_array, :only => [:show, :edit, :update, :destroy]
  before_filter :load_new_array, :only => [:new, :create]

  def index
  end

  def new
  end

  def create
    if @array.save
      flash[:notice] = 'Array was created.'
      redirect_to [:admin, @array]
    else
      render :new
    end
  end

  def show
  end

  def edit
  end

  def update
    if @array.update_attributes(params[:dynamic_array])
      flash[:notice] = 'Array was updated.'
      redirect_to [:admin, @array]
    else
      render :edit
    end
  end

  def destroy
    @array.destroy
    flash[:notice] = 'Array was deleted.'
    redirect_to admin_dynamic_arrays_path
  end


protected

  def load_arrays
    @arrays = DynamicArray.all(:order => 'name ASC')
  end

  def load_array
    @array = DynamicArray.find(params[:id])
  end

  def load_new_array
    @array = params[:dynamic_array].nil? ? DynamicArray.new : DynamicArray.new(params[:dynamic_array])
  end

end
