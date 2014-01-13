# -*- encoding: utf-8 -*-
class Tag < ActiveRecord::Base
  belongs_to :tagged, polymorphic: true
  belongs_to :user

  scope :uniques, group(:name)
  scope :by, lambda {|user| where(user_id: user) }
  scope :for, lambda {|tagged| where(tagged_id: tagged, tagged_type: tagged.is_a?(Array) ? tagged.first.class.name : tagged.class.name) }
  scope :hot, lambda {|limit| uniques.select("name, COUNT(name) AS name_count").reorder('name_count desc').limit(limit) }

  validates :tagged_id, :presence => true
  validates :user_id, :presence => true
  validates :name, :presence => true, :uniqueness => { scope: [ :tagged_id, :tagged_type ] }, :length => { minimum: 2 }

  default_scope order: 'created_at DESC'

  def shortname(length = 4)
    return self.name if self.name.size <= length
    self.name[0..length] + '...'
  end

  # Twitterハッシュタグ用
  # (句読点などを含むとハッシュタグとして認識されないためこれを取り除く)
  def hashtag
    self.name.gsub(/[^[:word:]]/,'')
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
