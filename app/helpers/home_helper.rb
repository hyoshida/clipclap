module HomeHelper
  def font_size_for_tag_cloud(tag, options={})
    options[:base_font_size] ||= 10
    options[:max_offset_size] ||= 30
    offset_font_size = (options[:max_offset_size] * (tag.name_count.to_f / options[:max_count].to_f)).floor
    "font-size: #{options[:base_font_size] + offset_font_size}pt"
  end
end
