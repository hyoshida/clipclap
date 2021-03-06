# -*- encoding: utf-8 -*-
module ApplicationHelper
  def meta_tags_attributes
    {
      site: Settings.site_name,
      description: Settings.site_description,
      keywords: [ Settings.site_name ] + Settings.site_keywords,
      open_graph: {
        title: Settings.site_name,
        url: root_url,
        image: [ root_url, 'favicon.png' ].join
      },
      twitter: {
        card: 'summary',
        site: Settings.twitter_account
      },
      separator: '-',
      reverse: true
    }
  end

  def icon_tag(icon_name, options ={})
    title = options[:title].try {|p| %{ title="#{p}"} } || ''
    raw %{<i class="icon-#{icon_name}"#{title}></i>}
  end

  def icon_heart
    raw '<i class="icon-heart"></i>'
  end

  def icon_heart_empty
    raw '<i class="icon-heart-empty"></i>'
  end

  def icon_clip
    raw '<i class="icon-paper-clip"></i>'
  end

  def icon_remove
    raw '<i class="icon-remove"></i>'
  end

  def like_count(clip)
    raw %{<span class="count">#{clip.like_count}</sapn>}
  end

  def comment_text_to(comment)
    h comment.body
  end

  def nostyle_like
    raw '<span style="display: none;">イイネ！</span>'
  end

  def nostyle_remove
    raw '<span style="display: none;">×</span>'
  end

  def like_to(clip, options={})
    default_options = { remote: true, title: 'イイネ！する' }
    link_to(icon_heart_empty + nostyle_like + like_count(clip), like_clip_path(clip), default_options.merge(options))
  end

  def unlike_to(clip, options={})
    default_options = { remote: true, title: 'イイネ！を取り消す', class: 'inactive' }
    link_to(icon_heart + nostyle_remove + like_count(clip), unlike_clip_path(clip), default_options.merge(options))
  end

  def reclip_to(clip, options={})
    default_options = { remote: true, method: :put, title: 'リクリップする' }
    link_to(icon_clip + "リクリップ", reclip_clip_path(clip), default_options.merge(options))
  end

  def unreclip_to(clip, options={})
    default_options = { remote: true, method: :put, title: 'リクリップを取り消す', class: 'inactive' }
    link_to(icon_clip + "リクリップ" + nostyle_remove, unreclip_clip_path(clip), default_options.merge(options))
  end

  def comment_to(comment)
    comment_text_to(comment)
  end

  def uncomment_to(comment)
    options = { remote: true, title: 'コメントを取り消す', class: 'remove' }
    remove_link = link_to(icon_remove + nostyle_remove, uncomment_clip_path(id: comment.clip_id, comment_id: comment.id), options)
    raw comment_text_to(comment) + remove_link
  end

  def follow_to(followable, options={})
    return unless user_signed_in?
    return if current_user == followable
    return if current_user.following?(followable)
    default_options = { title: 'フォローする', remote: true }
    link_to('フォロー', follow_user_path(followable), default_options.merge(options))
  end

  def unfollow_to(followable, options={})
    return unless user_signed_in?
    return unless current_user.following?(followable)
    default_options = { title: 'フォローを取り消す', remote: true }
    link_to('フォローを取り消す', unfollow_user_path(followable), default_options.merge(options))
  end

  def link_to_user_by_avatar(user, options={})
    link_to image_tag(avatar_url(user, options)), user_path(user), 'title' => user.nick_name, 'data-toggle' => 'tooltip', 'data-placement' => 'bottom', 'data-container' => 'body'
  end

  def avatar_url(user, options={})
    options = avatar_url_default_options.merge(options)
    gravatar_id = Digest::MD5.hexdigest(user.email.downcase)
    "http://gravatar.com/avatar/#{gravatar_id}.png?s=#{options[:size]}&d=#{options[:default]}"
  end

  def image_tag_by_clip(clip, options={})
    style = clip.size_for_stylesheet(options)
    style += background_thumbnail_for_stylesheet(clip, options)
    image_tag image_path(image_url_by_clip(clip, options)), alt: clip.title, style: style
  end

  def resource_name
    :user
  end

  def resource
    @resource ||= User.new
  end

  def devise_mapping
    @devise_mapping ||= Devise.mappings[:user]
  end

  private

  def avatar_url_default_options
    {
      default: 'identicon',
      size: 32
    }
  end

  def image_url_by_clip(clip, options={})
    case options[:mode].try(:to_sym)
    when :thumbnail, :crop
      clip.image.thumb_url
    else
      clip.image_id
    end
  end

  def background_thumbnail_for_stylesheet(clip, options={})
    return '' if options[:mode].to_s.in? %w( thumbnail crop )
    "background: url('#{image_path(clip.image.thumb_url)}') no-repeat center center; background-size: contain;"
  end
end
