# -*- encoding: utf-8 -*-
class Post < ActiveRecord::Base
  belongs_to :user

  #before_save :fill_origin_entry

  validates :url, :presence => true, :format => { :with => /^https?:\/\/.*\/.*\.(jpg|jpeg|png|gif)$/ }
  validates :origin_url, :allow_nil => true, :format => { :with => /^https?:\/\// }
  validates :origin_html, :allow_nil => true, :inclusion_html => { tags: [ 'img' ] }

  # TODO: DBにする
  attr_accessor :base_url
  attr_reader :error_info

  def listup_available_image_url
    require 'open-uri'
    require 'image_size'
    listup_image_url_from_html.select do |image_url|
      #begin
        fp = open(image_url) rescue ''
        image_size = ImageSize.new(fp)
        (image_size.size.present? && image_size.width > 16 && image_size.height > 16)
      # TODO: デバッグ用
      #rescue
      #  raise "base_uri=#{self.base_url}, url=#{image_url}, html=#{self.origin_html}: #{$!.message}"
      #end
    end
  end

  def create_html_only_images(html)
    require 'hpricot'
    doc = Hpricot(html || '')
    (doc/:img).to_html
  end

  def listup_image_url_from_html
    require 'hpricot'
    return [ self.origin_url ] if self.origin_url =~ /\.(jpg|jpeg|png|gif)$/
    doc = Hpricot(self.origin_html)
    (doc/:img).map {|img| uri_absolute_path(img.attributes['src']) }.uniq
  end

  def pickup_image_url_from_html
    listup_available_image_url.first
  end

  def fill_origin_entry
    require 'open-uri'

    self.origin_url.insert(0, 'http://') unless self.origin_url =~ /^http:\/\//

    if self.origin_url =~ /\.(jpg|jpeg|png|gif)$/
      self.url = self.origin_url
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
      self.url = image_url if image_url.present?
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
end
