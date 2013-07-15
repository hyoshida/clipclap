# -*- encoding: utf-8 -*-
class Tag < ActiveRecord::Base
  belongs_to :clip
  belongs_to :user

  validates :clip_id, :presence => true
  validates :user_id, :presence => true
  validates :name, :presence => true, :uniqueness => { scope: :clip_id }, :length => { minimum: 2 }

  def shortname(length = 4)
    return self.name if self.name.size <= length
    self.name[0..length] + '...'
  end
end
