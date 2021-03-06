# -*- encoding: utf-8 -*-
class Clip < ActiveRecord::Base
  include ActiveRecordExtension

  belongs_to :user
  belongs_to :image
  belongs_to :parent, class_name: 'Clip'
  belongs_to :origin, class_name: 'Clip'
  has_many :likes, :dependent => :destroy
  has_many :tags, :as => :tagged, :dependent => :destroy
  has_many :comments, :dependent => :destroy
  has_and_belongs_to_many :matomes

  default_scope order: 'created_at DESC'

  #before_save :fill_origin_entry

  validates :origin_url, :allow_nil => true, :format => { :with => /^https?:\/\// }
  validates :origin_html, :allow_nil => true, :inclusion_html => { tags: [ 'img' ] }

  attr_accessor :url
  # TODO: DBにする
  attr_accessor :base_url
  attr_reader :error_info

  before_create :create_image

  # TODO: kaminari に移行する
  self.per_page = Settings.page

  include OpenUriSweet

  def reclip?
    self.parent_id.present?
  end

  def reclips
    self.class.where(parent_id: self.id)
  end

  def reclip_count
    self.reclips.count
  end

  def origin_clip
    self.image.clip
  end

  def open_image
    options = {}
    options['Referer'] = self.origin_url if self.origin_url.present?
    open_uri_sweet(self.url, "rb:#{Encoding::ASCII_8BIT}", options)
  end

  def origin_url_domain
    return nil if self.origin_url.blank?
    require 'uri'
    return URI(self.origin_url).host
  end

  def increment_view_count!(request = nil)
    return false if self.last_access_ip == request.remote_ip
    self.class.without_record_timestamps do
      self.update_attributes(
        view_count: self.view_count + 1,
        last_access_ip: request.remote_ip
      )
    end
  end

  def tags_maximum?
    self.tags.size >= Settings.maximum_tag_count
  end

  def like_count
    self.likes.size
  end

  def create_image
    return true if self.parent_id
    return false if @url.nil?

    image = Image.where(url: @url).first
    if image.nil?
      require 'open-uri'
      require 'image_size'
      image_size = ImageSize.new(open_image)
      image = Image.create(url: @url, width: image_size.width, height: image_size.height)
      return false if image.nil?
    end

    self.image_id = image.id
  end

  def url
    self.image.try(:url) || @url
  end

  delegate :size_for_stylesheet, to: :image

  def create_html_only_images
    images = [ @url ] if @url
    images ||= self.listup_image_urls_from_html
    images.map do |url|
      ActionController::Base.helpers.image_tag(url)
    end.join
  end

  def create_html_only_images_with_pagenate(page)
    require 'will_paginate/array'
    create_html_only_images.paginate(page: page, per_page: self.class.per_page).join
  end

  def listup_image_urls_from_html
    require 'hpricot'
    return [] if self.origin_html.blank?
    return [ self.origin_url ] if self.origin_url =~ support_image_types_regexp
    doc = Hpricot(self.origin_html)
    image_urls_from(doc)
  end


  class BetterImageGetter
    def initialize(url)
      @uri = URI.parse(url)
      @service = @uri.host
    end

    def exec
      case @service
      when /pixiv\.net/
        @uri.to_s.sub(/(_128x128|87ms|240mw)\.jpg/, '_480mw.jpg')
      else
        @uri.to_s
      end
    end
  end

  def pickup_image_url_from_html
    listup_available_image_urls.first
  end

  def fill_origin_entry
    self.origin_url.insert(0, 'http://') unless self.origin_url =~ /^https?:\/\//

    if self.origin_url =~ support_image_types_regexp
      @url = self.origin_url
      return
    end

    open_uri_sweet(self.origin_url, 'r:binary') do |f|
      # 厳密な画像判定
      # f.content_type =~ /^image/

      self.base_url = f.base_uri.to_s[ /(?:http:\/\/)?.*\// ]
      # 変換できない文字があるときは適当な記号（デフォルトは ?）に置き換え
      # TODO: http://moeimg.blog133.fc2.com/ このサイトがうまくエンコードできない
      self.origin_html = f.read.encode(Encoding.default_internal, f.charset, invalid: :replace, undef: :replace)
    end
  end

  private

  def image_urls_from(doc)
    (
      image_urls_from_image_tags(doc/:img) +
      image_urls_from_anthor_tags(doc/:a) +
      # Hpricotで、目的のエレメントがテキストとして認識されてしまうので暫定処理
      # 本来あるべきセレクタ: doc/'[@style^="background"]'
      image_urls_from_css((doc/'.photo_stage').map(&:children))
    ).uniq
  end

  def image_urls_from_image_tags(image_tags)
    image_tags.map do |image_tag|
      image_url = image_tag.attributes['src']
      # TODO: altを活かす
      BetterImageGetter.new(uri_absolute_path(image_url)).exec
    end.uniq
  end

  def image_urls_from_anthor_tags(anchor_tags)
    anchor_tags.map do |anchor_tag|
      image_url = anchor_tag.attributes['href']
      next unless image_url =~ support_image_types_regexp
      BetterImageGetter.new(uri_absolute_path(image_url)).exec
    end.compact.uniq
  end

  # for tumblr
  def image_urls_from_css(tags)
    tags.map do |tag|
      # 暫定処置
      # 本来あるべき処理: attribute = tag.attributes['style']
      attribute = tag.join
      next if attribute.blank?

      match = attribute.match(/url\(['"]?(.+)['"]?\)/)
      next if match.nil?

      image_url = match[1]
      next unless image_url =~ support_image_types_regexp

      BetterImageGetter.new(uri_absolute_path(image_url)).exec
    end.compact.uniq
  end

  def support_image_types_regexp
    /\.(#{Settings.support_image_types.join('|')})$/
  end

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
