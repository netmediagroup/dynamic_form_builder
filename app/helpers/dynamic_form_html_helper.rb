module DynamicFormHtmlHelper

  def render_dynamic_form(df, options={})
    options.reverse_merge! :required_indicator => '*', :object_name => 'dynamic_form'
    @options = options
    @rendered_form = Array.new

    df.form.dynamic_fields.default_order.each do |field|
      @rendered_form << content_tag(:div, :id => "FormRow-#{field.column_name}", :class => "FormField-Row FieldType-#{field.field_type}#{(df.errors.on(field.column_name.to_sym) ? ' errored' : '')}") do 
        self.send("__#{field.field_type}", field, df.send(field.column_name))
      end
    end
    @rendered_form.join("\n")
  end

  def __required_indicator_tag(field)
    content_tag(:span, "#{@options[:required_indicator]}", :class => 'required')
  end

  def __checkbox(field, value)
    box = String.new
    box << required_indicator_tag(field) if field.required?
    box << content_tag(:div, :class => "FormField-Input") do 
      check_box_tag(@options[:object_name].blank? ? field.column_name : "#{@options[:object_name]}[#{field.column_name}]", :checked => (!value.blank?))
    end
    box << content_tag(:div, :class => "FormField-CheckboxLabel") do
      content_tag(:label, field.label, :for => "#{(@options[:object_name].blank? ? field.column_name : "#{@options[:object_name]}_#{field.column_name}")}")
    end
    return box
  end

  def __text_field(field, value)
    text = String.new
    text << __required_indicator_tag(field) if field.required?
    text << content_tag(:div, :class => "FormField-CheckboxLabel") do
      content_tag(:label, field.label, :for => "#{(@options[:object_name].blank? ? field.column_name : "#{@options[:object_name]}_#{field.column_name}")}")
    end
    text << content_tag(:div, :class => "FormField-Input") do 
      text_field_tag(@options[:object_name].blank? ? field.column_name : "#{@options[:object_name]}[#{field.column_name}]", value || field.fieldable.prompt)
    end
    return text
  end

  def __select(field, values)
    text = String.new
    text << __required_indicator_tag(field) if field.required?
    text << content_tag(:div, :class => "FormField-CheckboxLabel") do
      content_tag(:label, field.label, :for => "#{(@options[:object_name].blank? ? field.column_name : "#{@options[:object_name]}_#{field.column_name}")}")
    end
    text << content_tag(:div, :class => "FormField-Input") do
      selected_items = values || field.fieldable.default_items.map{|default| default.value} || nil
      select_items = Array.new
      if field.fieldable.combine_option_groups
        field.fieldable.dynamic_array_groups.default_order.each do |group|
          select_items += group.dynamic_array.dynamic_array_items.default_order.map{|item| [item.item_display, item.item_value]}
        end
        select_items.sort!{|a,b| (a[0] || '') <=> (b[0] || '')}.uniq
        select_items.unshift [field.fieldable.prompt, nil] if !field.fieldable.prompt.nil? && field.fieldable.default_items.blank? && values.blank?
        options = options_for_select(select_items, selected_items)
      else
        field.fieldable.dynamic_array_groups.default_order.each do |group|
          select_items << [[group.name], group.dynamic_array.dynamic_array_items.default_order.map{|item| [item.item_display, item.item_value]}]
        end
        prompt = (field.fieldable.default_items.blank? && values.blank?) ? field.fieldable.prompt : nil
        options = grouped_options_for_select(select_items, selected_items, prompt)
      end
      
      select_tag(@options[:object_name].blank? ? field.column_name : "#{@options[:object_name]}[#{field.column_name}]", options, :multiple => true)
    end
    return text
  end

  def __phone(field, value)
  end

  def __file(field, value)
  end

  def __hidden_field(field, value)
  end

  def __password(field, value)
  end

  def __radio(field, value)
  end

  def __text_area(field, value)
  end

end
