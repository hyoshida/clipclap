module TagsHelper
  def image_tag_for_tag_small(clip)
    style = clip.thumb_size_for_style_sheet(mode: :crop, size: (Settings.thumb_width / 3.0).floor)
    image_tag image_path(clip.image), alt: clip.title, style: style
  end

  def image_tag_for_tag(clip)
    style = clip.thumb_size_for_style_sheet(mode: :crop, size: Settings.thumb_width)
    image_tag image_path(clip.image), alt: clip.title, style: style
  end
end
