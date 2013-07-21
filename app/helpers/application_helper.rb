# -*- encoding: utf-8 -*-
module ApplicationHelper
  def icon_tag(icon_name, options ={})
    title = options[:title].try {|p| %{ title="#{p}"} } || ''
    raw %{<i class="icon-#{icon_name}"#{title}></i>}
  end

  def icon_heart
    raw '<i class="icon-heart" title="イイネ！"></i>'
  end

  def icon_heart_empty
    raw '<i class="icon-heart-empty" title="イイネ！"></i>'
  end

  def icon_remove
    raw '<i class="icon-remove" title="取り消す"></i>'
  end

  def like_text_to(clip)
    raw icon_heart + clip.like_count.to_s
  end

  def comment_text_to(comment)
    raw comment.body
  end

  def nostyle_like
    raw '<span style="display: none;">イイネ！</span>'
  end

  def nostyle_remove
    raw '<span style="display: none;">×</span>'
  end

  def like_to(clip)
    link_to(icon_heart_empty + nostyle_like + clip.like_count.to_s, like_clip_path(:id => clip), title: 'イイネ！する', remote: true)
  end

  def unlike_to(clip)
    remove_link = ''
    remove_link = link_to(icon_remove + nostyle_remove, unlike_clip_path(:id => clip), title: 'イイネ！を取り消す', remote: true) if user_signed_in? 
    like_text_to(clip) + remove_link
  end

  def comment_to(comment)
    comment_text_to(comment)
  end

  def uncomment_to(comment)
    remove_link = link_to(icon_remove + nostyle_remove, uncomment_clip_path(:id => comment.clip_id, :comment_id => comment), title: 'コメントを取り消す', remote: true)
    comment_text_to(comment) + remove_link
  end

  def avatar_url(user, size=32)
    gravatar_id = Digest::MD5.hexdigest(user.email.downcase)
    "http://gravatar.com/avatar/#{gravatar_id}.png?s=#{size}"
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
end
