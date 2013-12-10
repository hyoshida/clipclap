# -*- encoding: utf-8 -*-
class Like < ActiveRecord::Base
  belongs_to :clip
  belongs_to :user
  belongs_to :image
  belongs_to :matome

  validates :clip_id, :presence => true, :unless => :exist_matome?
  validates :user_id, :presence => true
  validates :image, :presence => true, :if => :exist_clip?
  validates :matome_id, :presence => true, :unless => :exist_clip?

  default_scope order: 'created_at DESC'

  private

  def exist_clip?
    not self.clip_id.nil?
  end

  def exist_matome?
    not self.matome_id.nil?
  end
end
