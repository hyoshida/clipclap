# -*- encoding: utf-8 -*-
class Like < ActiveRecord::Base
  belongs_to :post
  belongs_to :user
  belongs_to :image_master
end
