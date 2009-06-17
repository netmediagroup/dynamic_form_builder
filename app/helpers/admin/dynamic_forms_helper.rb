module Admin::DynamicFormsHelper

  # I know this is an ugly way to code this, but right now it doesn't matter.
  def render_partial_if_exists(partial)
    view_paths.each do |path|
      return render partial if File.exists?(File.join(path, params[:controller], "_#{partial}.html.erb"))
    end
    return nil
  end

end
