# -*- encoding: utf-8 -*-
class Tag < ActiveRecord::Base
  belongs_to :tagged, polymorphic: true
  belongs_to :user

  scope :uniques, group(:name)
  scope :by, lambda {|user| where(user_id: user.id) }

  validates :tagged_id, :presence => true
  validates :user_id, :presence => true
  validates :name, :presence => true, :uniqueness => { scope: :clip_id }, :length => { minimum: 2 }

  default_scope order: 'created_at DESC'

  def shortname(length = 4)
    return self.name if self.name.size <= length
    self.name[0..length] + '...'
  end

  def clips
    case self.tagged
    when Clip
      [ self.tagged ]
    when Matome
      self.tagged.clips
    end
  end

  def clip
    self.clips.first
  end
end
