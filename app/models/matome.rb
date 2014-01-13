class Matome < ActiveRecord::Base
  include ActiveRecordExtension

  belongs_to :user
  has_many :clips
  has_many :likes, dependent: :destroy
  has_many :tags, as: :tagged, dependent: :destroy
  has_and_belongs_to_many :clips

  scope :hot, lambda {|limit| reorder('view_count desc').limit(limit) }

  default_scope order: 'matomes.created_at DESC'

  validates :user_id, presence: true
  validates :title, presence: true
  validates :description, allow_blank: true, length: { maximum: 150 }

  attr_accessible :title
  attr_accessible :description
  attr_accessible :view_count
  attr_accessible :last_access_ip

  paginates_per Settings.page

  def increment_view_count!(request = nil)
    return false if self.last_access_ip == request.remote_ip
    self.class.without_record_timestamps do
      self.update_attributes(
        view_count: self.view_count + 1,
        last_access_ip: request.remote_ip
      )
    end
  end

  def related_by_user
    self.class.
      where(user_id: self.user_id).
      where.not(id: self.id)
  end

  def related_by_clips
    related_clip_ids = self.clips.map(&:id) + self.clips.map(&:parent_id)
    self.class.
      joins(:clips).
      where(Clip.arel_table[:id].in(related_clip_ids).or(Clip.arel_table[:parent_id].in(related_clip_ids))).
      where.not('matomes.id' => self.id).
      group('matomes.id')
  end

  def related_by_tags
    (related_by_clip_tags + related_by_matome_tags).uniq
  end

  private

  def related_by_clip_tags
    self.class.
      joins(:clips).
      merge(related_clips_by_tags).
      where.not('matomes.id' => self.id).
      group('matomes.id')
  end

  def related_by_matome_tags
    self.class.
      joins(:tags).
      merge(related_tags).
      where.not('matomes.id' => self.id).
      group('matomes.id')
  end

  def related_tags
    related_tag_ids_to_matome = self.tags.uniques.pluck(:name)
    related_tag_ids_to_clips = Tag.uniques.for(self.clips).pluck(:name)
    Tag.uniques.where(name: (related_tag_ids_to_matome + related_tag_ids_to_clips).uniq)
  end

  def related_clips_by_tags
    Clip.joins(:tags).merge(related_tags)
  end
end
