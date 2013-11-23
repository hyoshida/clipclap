module MatomesHelper
  def image_tag_for_matome_cover(clip)
    image_tag_by_clip(clip, mode: :crop, size: 100)
  end
end
