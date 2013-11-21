# -*- encoding: utf-8 -*-
class Image < ActiveRecord::Base
  has_many :clips
  has_many :likes

  #validates :url, :uniqueness => true, :presence => true, :format => { :with => /^https?:\/\/.*\/.*\.(jpg|jpeg|png|gif)$/ }
  validates :url, :uniqueness => true, :presence => true, :format => { :with => /^https?:\/\/.*\/.*$/ }
  validates :width, :numericality => { :greater_than => Settings.minimum_image_width }
  validates :height, :numericality => { :greater_than => Settings.minimum_image_height }
  validates_with ImageAspectValidator, :width => :width, :height => :height, :aspect => Settings.allowed_image_aspect

  include OpenUriSweet

  def thumb_path
    require 'digest/sha2'
    sha256 = Digest::SHA256.hexdigest(self.url)
    File.join(Settings.image_cache_dir, [ sha256, Settings.thumb_format ].join)
  end

  def create_thumb_cache_file
    FileUtils.mkdir_p Settings.image_cache_dir unless File.exist? Settings.image_cache_dir
    image = MiniMagick::Image.read(open_uri_sweet(self.url, "rb:#{Encoding::ASCII_8BIT}").read)
    image.format Settings.thumb_format
    image.resize "#{self.thumb_width}x#{self.thumb_height}"
    image.write self.thumb_path
  end

  def thumb_width(size_type=nil)
    case size_type
    when :tag
      return Settings.thumb_width if self.thumb_width < self.thumb_height
      (self.width * (self.thumb_height(:tag) / self.height.to_f)).floor
    else
      Settings.thumb_width
    end
  end

  def thumb_height(size_type=nil)
    return 0 if self.width.zero? || self.height.zero? # for 下位互換
    case size_type
    when :tag
      return self.thumb_height if self.thumb_width < self.thumb_height
      Settings.thumb_width
    else
      (self.height * (self.thumb_width / self.width.to_f)).floor
    end
  end

  def thumb_size_for_style_sheet(size_type=nil)
    return "width: #{self.thumb_width}px;" if self.thumb_height.zero? # for 下位互換
    case size_type
    when :tag, :tag_small
      width = self.thumb_width(:tag)
      height = self.thumb_height(:tag)
      if size_type == :tag_small
        width = (width / 3.0).floor
        height = (height / 3.0).floor
      end
      width_offset = width - Settings.thumb_width
      height_offset = height - Settings.thumb_width
      "width: #{width}px; height: #{height}px; margin-left: -#{width_offset/2}px; margin-top: -#{height_offset/2}px;"
    else
      "width: #{self.thumb_width}px; height: #{self.thumb_height}px;"
    end
  end
end
