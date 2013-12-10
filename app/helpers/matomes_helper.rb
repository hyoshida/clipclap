module MatomesHelper
  def image_tag_for_matome_cover(clip)
    image_tag_by_clip(clip, mode: :crop, size: 100)
  end

  def like_to_matome(matome, options={})
    default_options = { method: :post, remote: true }
    link_to('イイネ！', like_matome_path(matome), default_options.merge(options))
  end

  def unlike_to_matome(matome, options={})
    default_options = { method: :delete, remote: true }
    link_to('イイネ！を取り消す', like_matome_path(matome), default_options.merge(options))
  end
end
