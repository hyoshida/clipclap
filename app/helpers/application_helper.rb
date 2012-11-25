# -*- encoding: utf-8 -*-
module ApplicationHelper
  def like_text_to(post)
    raw "<span class=\"icon-heart\">#{post.like_count}</span>"
  end

  def nostyle_like
    raw '<span style="display: none;">イイネ！</span>'
  end

  def nostyle_unlike
    raw '<span style="display: none;">×</span>'
  end

  def like_to(post)
    link_to(nostyle_like + post.like_count.to_s, like_post_path(:id => post), class: 'icon-heart', title: 'イイネ！する', remote: true)
  end

  def unlike_to(post)
    remove_link = ''
    remove_link = link_to(nostyle_unlike, unlike_post_path(:id => post), class: 'icon-remove', title: 'イイネ！を取り消す', remote: true) if user_signed_in?
    nostyle_like + like_text_to(post) + remove_link
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
