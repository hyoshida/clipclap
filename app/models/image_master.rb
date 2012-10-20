# -*- encoding: utf-8 -*-
class ImageMaster < ActiveRecord::Base
  has_many :posts

  #validates :url, :uniqueness => true, :presence => true, :format => { :with => /^https?:\/\/.*\/.*\.(jpg|jpeg|png|gif)$/ }
  validates :url, :uniqueness => true, :presence => true, :format => { :with => /^https?:\/\/.*\/.*$/ }
end
