# -*- encoding: utf-8 -*-
class Like < ActiveRecord::Base
  belongs_to :post
  belongs_to :user
  belongs_to :image_master

  validates :post_id, :presence => true
  validates :user_id, :presence => true
  validates :image_master, :presence => true
end
