# -*- encoding: utf-8 -*-
class ImageMaster < ActiveRecord::Base
  has_many :clips
  has_many :likes

  #validates :url, :uniqueness => true, :presence => true, :format => { :with => /^https?:\/\/.*\/.*\.(jpg|jpeg|png|gif)$/ }
  validates :url, :uniqueness => true, :presence => true, :format => { :with => /^https?:\/\/.*\/.*$/ }

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
