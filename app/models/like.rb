# -*- encoding: utf-8 -*-
class Like < ActiveRecord::Base
  belongs_to :clip
  belongs_to :user
  belongs_to :image_master

  validates :clip_id, :presence => true
  validates :user_id, :presence => true
  validates :image_master, :presence => true
end
