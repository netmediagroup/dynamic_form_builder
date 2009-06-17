class Admin::DynamicFormsController < ApplicationController
  before_filter :load_forms, :only => [:index]
  before_filter :load_form, :only => [:show, :edit, :update, :destroy]
  before_filter :load_new_form, :only => [:new, :create]
  before_filter :load_redirect_to_form, :only => [:new, :create, :edit, :update]

  def index
  end

  def new
  end

  def create
    if @dynamic_form.save
      flash[:notice] = 'Form was created.'
      redirect_to @redirect_to_form
    else
      render :new
    end
  end

  def show
  end

  def edit
  end

  def update
    if @dynamic_form.update_attributes(params[:dynamic_form])
      flash[:notice] = 'Form was updated.'
      redirect_to @redirect_to_form
    else
      render :edit
    end
  end

  def destroy
    @dynamic_form.destroy
    flash[:notice] = 'Form was deleted.'
    redirect_to nil
  end


protected

  def load_forms
    @forms = DynamicForm.all(:order => 'name ASC')
  end

  def load_form
    @dynamic_form = DynamicForm.find(params[:id])
  end

  def load_new_form
    @dynamic_form = params[:dynamic_form].nil? ? DynamicForm.new : DynamicForm.new(params[:dynamic_form])
  end

  def load_redirect_to_form
    @redirect_to_form = [:admin, @dynamic_form]
  end

end
