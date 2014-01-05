module TagsHelper
  def image_tag_for_tag_small(clip)
    image_tag_by_clip(clip, mode: :crop, size: (Settings.thumb_width / 3.0).floor)
  end

  def image_tag_for_tag(clip)
    image_tag_by_clip(clip, mode: :crop, size: Settings.thumb_width)
  end

  def tagged_type
    return if params[:type].blank?
    params[:type].to_sym
  end

  def tagged_type_name
    case tagged_type
    when :clips
      'クリップ'
    when :matomes
      'まとめ'
    else
      'クリップ/まとめ'
    end
  end

  def tag_for_all?
    return false if tag_for_clip?
    return false if tag_for_matome?
    true
  end

  def tag_for_clip?
    tagged_type == :clips
  end

  def tag_for_matome?
    tagged_type == :matomes
  end

  def count_tag_for_all
    Tag.where(name: params[:name]).count
  end

  def count_tag_for_clip
    Tag.where(name: params[:name], tagged_type: 'Clip').count
  end

  def count_tag_for_matome
    Tag.where(name: params[:name], tagged_type: 'Matome').count
  end
end
