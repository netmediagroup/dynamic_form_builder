class Admin::DynamicArrayItemsController < Admin::AdminController
  before_filter :load_array, :only => [:index, :new, :create, :edit_sort, :new_items, :create_items]
  before_filter :load_array_items, :only => [:index, :edit_sort]
  before_filter :load_array_item, :only => [:show, :edit, :update, :destroy]
  before_filter :load_new_array_item, :only => [:new, :create]
  before_filter :load_form_action_new, :only => [:new, :create]
  before_filter :load_form_action_edit, :only => [:edit, :update]

  def index
  end

  def new
  end

  def create
    if @array_item.save
      flash[:notice] = 'Array was created.'
      redirect_to [:admin, @array_item]
    else
      render :new
    end
  end

  def show
  end

  def edit
  end

  def update
    if @array_item.update_attributes(params[:dynamic_array_item])
      flash[:notice] = 'Array item was updated.'
      redirect_to [:admin, @array_item]
    else
      render :edit
    end
  end

  def destroy
    @array_item.destroy
    flash[:notice] = 'Array item was deleted.'
    redirect_to admin_dynamic_array_dynamic_array_items_path(@array_item.dynamic_array)
  end

  def edit_sort
  end

  def update_sort
    params[:items_list].each_index do |i|
      id = params[:items_list].fetch(i)
      DynamicArrayItem.find(id).update_attribute('sort', i)
    end
    render :nothing => true
  end

  def new_items
  end

  def create_items
    items = params[:items].split("\r\n").collect{|i| i.split("\t")}
    items.each do |item|
      @array.dynamic_array_items.create(:item_display => item[0], :item_value => item[1]) if item.size == 2
    end
    redirect_to admin_dynamic_array_dynamic_array_items_path(@array)
  end


protected

  def load_array
    @array = DynamicArray.find(params[:dynamic_array_id])
  end

  def load_array_items
    @array_items = @array.dynamic_array_items.default_order
  end

  def load_array_item
    @array_item = DynamicArrayItem.find(params[:id])
  end

  def load_new_array_item
    @array_item = params[:dynamic_array_item].nil? ? @array.dynamic_array_items.new : @array.dynamic_array_items.new(params[:dynamic_array_item])
  end

  def load_form_action_new
    @form_action = [:admin, @array, @array_item]
  end

  def load_form_action_edit
    @form_action = [:admin, @array_item]
  end

end
