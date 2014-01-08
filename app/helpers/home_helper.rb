module HomeHelper
  def font_size_for_tag_cloud(tag, options={})
    options[:base_font_size] = 9
    options[:offset_ratio] = 0.5
    options[:max_offset_size] = 50
    offset_font_size = [tag.name_count * options[:offset_ratio], options[:max_offset_size]].min.floor
    "font-size: #{options[:base_font_size] + offset_font_size}pt"
  end
end
