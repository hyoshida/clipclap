module TagsHelper
  def image_tag_for_tag_small(clip)
    image_tag_by_clip(clip, mode: :crop, size: (Settings.thumb_width / 3.0).floor)
  end

  def image_tag_for_tag(clip)
    image_tag_by_clip(clip, mode: :crop, size: Settings.thumb_width)
  end
end
