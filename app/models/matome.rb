class Matome < ActiveRecord::Base
  include ActiveRecordExtension

  belongs_to :user
  has_many :clips
  has_many :likes, dependent: :destroy
  has_many :tags, as: :tagged, dependent: :destroy
  has_and_belongs_to_many :clips

  scope :related_by_user, lambda {|matome|
    where(user_id: matome.user_id).
    where.not(id: matome.id)
  }
  scope :related_by_clips, lambda {|matome|
    related_clip_ids = matome.clips.map(&:id) + matome.clips.map(&:parent_id)
    joins(:clips).
    where(Clip.arel_table[:id].in(related_clip_ids).or(Clip.arel_table[:parent_id].in(related_clip_ids))).
    where.not('matomes.id' => matome.id).
    group('matomes.id')
  }
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
end
