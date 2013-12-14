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

  def open_image
    clip = clips.first
    return clip.open_image if clip
    options = {}
    options['Referer'] = self.url if self.url.present?
    open_uri_sweet(self.url, "rb:#{Encoding::ASCII_8BIT}", options)
  end

  def thumb_url
    [ self.id, :thumbnail ].join('/')
  end

  def thumb_path
    require 'digest/sha2'
    sha256 = Digest::SHA256.hexdigest(self.url)
    File.join(Settings.image_cache_dir, [ sha256, Settings.thumb_format ].join)
  end

  def create_thumb_cache_file
    FileUtils.mkdir_p Settings.image_cache_dir unless File.exist? Settings.image_cache_dir
    image = MiniMagick::Image.read(self.open_image.read)
    image.format Settings.thumb_format
    image.resize "#{self.thumb_width}x#{self.thumb_height}!"
    image.write self.thumb_path
  end

  def thumb_width(crop_size=nil)
    if crop_size
      return crop_size if self.thumb_width < self.thumb_height
      (self.width * (crop_size / self.height.to_f)).floor
    else
      Settings.thumb_width
    end
  end

  def thumb_height(crop_size=nil)
    return 0 if self.width.zero? || self.height.zero? # for 下位互換
    if crop_size
      return crop_size if self.thumb_width >= self.thumb_height
      (self.height * (crop_size / self.width.to_f)).floor
    else
      (self.height * (self.thumb_width / self.width.to_f)).floor
    end
  end

  def size_for_stylesheet(options={})
    case options[:mode]
    when :crop
      crop_size = options[:size]
      width = self.thumb_width(crop_size)
      height = self.thumb_height(crop_size)
      width_offset = width - crop_size
      height_offset = height - crop_size
      "width: #{width}px; height: #{height}px; margin-left: -#{width_offset / 2}px; margin-top: -#{height_offset / 2}px;"
    when :thumbnail
      "width: #{self.thumb_width}px; height: #{self.thumb_height}px;"
    else
      width = self.width
      height = self.height
      if options[:max_width] && width > options[:max_width]
        height = (height * (options[:max_width] / width.to_f)).floor
        width = options[:max_width]
      end
      "width: #{width}px; height: #{height}px;"
    end
  end
end
