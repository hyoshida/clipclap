# -*- encoding: utf-8 -*-
class Tag < ActiveRecord::Base
  belongs_to :post
  belongs_to :user

  validates :post_id, :presence => true
  validates :user_id, :presence => true
  validates :name, :presence => true, :uniqueness => true, :length => { :minimum => 2 }
end
