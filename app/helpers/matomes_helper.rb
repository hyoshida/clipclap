module MatomesHelper
  def image_tag_for_matome_cover(clip)
    style = clip.thumb_size_for_style_sheet(mode: :crop, size: 100)
    image_tag image_path(clip.image), alt: clip.title, style: style
  end
end
