# -*- encoding: utf-8 -*-
class Image < ActiveRecord::Base
  has_many :clips
  has_many :likes

  #validates :url, :uniqueness => true, :presence => true, :format => { :with => /^https?:\/\/.*\/.*\.(jpg|jpeg|png|gif)$/ }
  validates :url, :uniqueness => true, :presence => true, :format => { :with => /^https?:\/\/.*\/.*$/ }

  def thumb_path
    require 'digest/sha2'
    sha256 = Digest::SHA256.hexdigest(self.url)
    File.join(Settings.image_cache_dir, [ sha256, File.extname(self.url) ].join)
  end

  def create_thumb_cache_file
    require 'open-uri'
    FileUtils.mkdir Settings.image_cache_dir unless File.exist? Settings.image_cache_dir
    File.open(self.thumb_path, 'wb') do |file|
      image_data = OpenURI.open_uri(self.url, "rb:#{Encoding::ASCII_8BIT}").read
      file.write(image_data)
    end
  end

  def thumb_width
    Settings.thumb_width
  end

  def thumb_height
    return 0 if self.width.zero? || self.height.zero? # for 下位互換
    (self.height * (self.thumb_width / self.width.to_f)).floor
  end

  def thumb_size_for_style_sheet
    return "width: #{self.thumb_width}px;" if self.thumb_height.zero? # for 下位互換
    "width: #{self.thumb_width}px; height: #{self.thumb_height}px;"
  end
end
