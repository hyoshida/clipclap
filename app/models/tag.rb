# -*- encoding: utf-8 -*-
class Tag < ActiveRecord::Base
  belongs_to :tagged, polymorphic: true
  belongs_to :user

  scope :uniques, group(:name)
  scope :by, lambda {|user| where(user_id: user.id) }
  scope :for, lambda {|tagged| where(tagged_id: tagged.id, tagged_type: tagged.class.name) }

  validates :tagged_id, :presence => true
  validates :user_id, :presence => true
  validates :name, :presence => true, :uniqueness => { scope: [ :tagged_id, :tagged_type ] }, :length => { minimum: 2 }

  default_scope order: 'created_at DESC'

  def shortname(length = 4)
    return self.name if self.name.size <= length
    self.name[0..length] + '...'
  end

  def all_clips
    case self.tagged
    when Clip
      [ self.tagged ]
    when Matome
      self.tagged.clips
    end
  end

  def all_clip
    self.all_clips.first
  end

  def clip
    self.tagged if self.tagged.is_a? Clip
  end

  def matome
    self.tagged if self.tagged.is_a? Matome
  end
end
