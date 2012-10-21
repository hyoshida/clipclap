# -*- encoding: utf-8 -*-
class Post < ActiveRecord::Base
  belongs_to :user
  belongs_to :image_master

  #before_save :fill_origin_entry

  validates :origin_url, :allow_nil => true, :format => { :with => /^https?:\/\// }
  validates :origin_html, :allow_nil => true, :inclusion_html => { tags: [ 'img' ] }

  attr_accessor :url
  # TODO: DBにする
  attr_accessor :base_url
  attr_reader :error_info

  before_create :create_image_master

  self.per_page = Settings.page

  def like(user)
    return false if user.like? self
    user.like self
    return false unless user.save
    self.like_count += 1
    self.image_master.like_count += 1
    self.save
  end

  def unlike(user)
    return false if user.unlike? self
    user.unlike self
    return false unless user.save
    self.like_count -= 1
    self.image_master.like_count -= 1
    self.save
  end

  def create_image_master
    require 'open-uri'
    require 'image_size'
    image_size = ImageSize.new(open(@url))
    image_master = ImageMaster.create(url: @url, width: image_size.width, height: image_size.height)
    self.image_master_id = image_master.id
  end

  def url
    self.image_master.try(:url) || @url
  end

  def thumb_size_for_style_sheet
    return "width: #{self.thumb_width}px;" if self.thumb_height.zero? # for 下位互換
    "width: #{self.thumb_width}px; height: #{self.thumb_height}px;"
  end

  def thumb_width
    Settings.thumb_width
  end

  def thumb_height
    return 0 if self.image_master.width.zero? || self.image_master.height.zero? # for 下位互換
    (self.image_master.height * (self.thumb_width / self.image_master.width.to_f)).floor
  end

  def create_html_only_images
    self.listup_available_image_urls.map {|url| create_image_tag_by_image_url(url) }.join
  end

  def create_html_only_images_with_pagenate(page)
    require 'will_paginate/array'
    create_html_only_images.paginate(page: page, per_page: self.class.per_page).join
  end

  def listup_available_image_urls
    require 'open-uri'
    require 'image_size'
    listup_image_urls_from_html.select do |image_url|
      file = open(image_url) rescue next
      image_size = ImageSize.new(file)
      (image_size.size.present? && available_size_image?(image_size) && available_aspect_image?(image_size))
    end
  end

  def listup_image_urls_from_html
    require 'hpricot'
    return [] if self.origin_html.blank?
    return [ self.origin_url ] if self.origin_url =~ /\.(jpg|jpeg|png|gif)$/
    doc = Hpricot(self.origin_html)
    # TODO: alt をそいでいる・・
    (doc/:img).map {|img| uri_absolute_path(img.attributes['src']) }.uniq
  end

  def pickup_image_url_from_html
    listup_available_image_urls.first
  end

  def fill_origin_entry
    require 'open-uri'

    self.origin_url.insert(0, 'http://') unless self.origin_url =~ /^http:\/\//

    if self.origin_url =~ /\.(jpg|jpeg|png|gif)$/
      @url = self.origin_url
      return
    end

    # TODO: SSL 通信に対応させる(いまは例外発生)
    open(self.origin_url, 'r:binary') do |f|
      # 厳密な画像判定
      # f.content_type =~ /^image/

      self.base_url = f.base_uri.to_s[ /(?:http:\/\/)?.*\// ]
      # 変換できない文字があるときは適当な記号（デフォルトは ?）に置き換え
      # TODO: http://moeimg.blog133.fc2.com/ このサイトがうまくエンコードできない
      self.origin_html = f.read.encode(Encoding.default_internal, f.charset, invalid: :replace, undef: :replace)

      image_url = pickup_image_url_from_html
      @url = image_url if image_url.present?
    end
  rescue
    @error_info = $!.message
  end

  private

  def uri_absolute_path(path)
    require 'uri'
    return path if path =~ /^http/
    URI.join(self.base_url, path).to_s
  end

  def uri_relative_path(path)
    require 'uri'
    return URI.parse(path).path if path =~ /^http/
    path
  end

  def create_image_tag_by_image_url(url)
    "<img src=\"#{url}\" style=\"width: 180px\" />"
  end

  def available_size_image?(image_size)
    image_size.width > 16 && image_size.height > 16
  end

  def available_aspect_image?(image_size)
    aspect = [ 16, 5 ]
    image_aspect = 1.0 * image_size.width / image_size.height
    image_aspect < (aspect[0] / aspect[1]) && image_aspect > (aspect[1] / aspect[0])
  end
end
